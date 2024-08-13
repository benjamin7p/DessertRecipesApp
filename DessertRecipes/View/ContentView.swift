//
//  ContentView.swift
//  DessertRecipes
//
//  Created by Benjamin Poulsen on 8/7/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MealListViewModel()
    @State private var selectedMealID: String? = nil
    
    var body: some View {
        NavigationView {
            List(viewModel.meals) { meal in
                NavigationLink(destination: MealDetailView(mealID: meal.idMeal)) {
                    HStack {
                        AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Text(meal.strMeal)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Dessert Recipes")
            .task {
                await viewModel.fetchDesserts()
            }
        }
    }
}

struct MealDetailView: View {
    @StateObject private var viewModel = MealDetailViewModel()
    var mealID: String
    
    var body: some View {
        VStack(alignment: .leading) {
            if let mealDetail = viewModel.mealDetail {
                Text(mealDetail.strMeal)
                    .font(.largeTitle)
                    .padding()
                
                AsyncImage(url: URL(string: mealDetail.strMealThumb)) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(height: 200)
                } placeholder: {
                    ProgressView()
                }
                .padding()
                
                Text("Instructions")
                    .font(.headline)
                    .padding(.top)
                
                ScrollView {
                    Text(mealDetail.strInstructions)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                }
                .padding(.bottom)
                
                Text("Ingredients")
                    .font(.headline)
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(Array(zip(mealDetail.ingredients.indices, mealDetail.ingredients)), id: \.0) { index, ingredient in
                            if let ingredient = ingredient, !ingredient.isEmpty {
                                HStack {
                                    Text("- \(ingredient)")
                                        .lineLimit(nil)
                                    if let measure = mealDetail.measures[index], !measure.isEmpty {
                                        Text(" \(measure)")
                                            .lineLimit(nil)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.bottom)
            } else {
                ProgressView()
            }
        }
        .padding()
        .navigationTitle("Meal Detail")
        .task {
            await viewModel.fetchMealDetail(for: mealID)
        }
    }
}
