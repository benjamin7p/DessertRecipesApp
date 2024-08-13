//
//  ViewModel.swift
//  DessertRecipes
//
//  Created by Benjamin Poulsen on 8/13/24.
//

import Foundation

@MainActor
class MealListViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var selectedMealID: String? = nil
    
    private let networkController = NetworkController.shared
    
    init() {
        Task {
            await fetchDesserts()
        }
    }
    
    func fetchDesserts() async {
        do {
            let fetchedMeals = try await networkController.fetchDesserts()
            self.meals = fetchedMeals.sorted { $0.strMeal < $1.strMeal }
        } catch {
            print("Failed to fetch desserts: \(error)")
        }
    }
    
    func selectMeal(_ meal: Meal) {
        self.selectedMealID = meal.idMeal
    }
}

@MainActor
class MealDetailViewModel: ObservableObject {
    @Published var mealDetail: MealDetail?
    
    private let networkController = NetworkController.shared
    
    func fetchMealDetail(for id: String) async {
        do {
            let fetchedDetail = try await networkController.fetchMealDetails(id: id)
            self.mealDetail = fetchedDetail
        } catch {
            print("Failed to fetch meal details: \(error)")
        }
    }
}
