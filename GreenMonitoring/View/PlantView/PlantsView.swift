//
//  PlantsView.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 02.06.2025.
//
import SwiftUI

struct PlantsView: View {
    let userId: String
    @StateObject var viewModel = PlantsViewModel()

    @State private var showingForm = false
    @State private var selectedPlantForEdit: Plant? = nil
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.plants.isEmpty {
                    Text("У вас поки немає рослин")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.plants) { plant in
                            PlantRowView(plant: plant)
                                .swipeActions {
                                    Button("Редагувати") {
                                        selectedPlantForEdit = plant
                                        showingForm = true
                                    }
                                    .tint(.blue)

                                    Button("Видалити", role: .destructive) {
                                        if let index = viewModel.plants.firstIndex(where: { $0.id == plant.id }) {
                                            viewModel.deletePlants(at: IndexSet(integer: index), userId: userId)
                                        }
                                    }
                                }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("🌱 Мої рослини")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedPlantForEdit = nil // нова рослина
                        showingForm = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                viewModel.fetchPlants(userId: userId)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // трошки почекаємо, щоб встигли завантажитись
                    for plant in viewModel.plants {
                        if plant.needsWater {
                            alertMessage = "Рослина \"\(plant.name)\" потребує поливу 🌱"
                            showAlert = true
                            break
                        } else if plant.needsLight {
                            alertMessage = "Рослині \"\(plant.name)\" бракує світла ☀️"
                            showAlert = true
                            break
                        }
                    }
                }
            }
            .sheet(isPresented: $showingForm) {
                AddEditPlantView(
                    viewModel: viewModel,
                    userId: userId,
                    plantToEdit: selectedPlantForEdit
                )
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Увага"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("Гаразд"))
                )
            }
        }
    }
}
