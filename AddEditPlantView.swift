//
//  AddEditPlantView.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 19.06.2025.
//

import SwiftUI

struct AddEditPlantView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PlantsViewModel
    let userId: String
    var plantToEdit: Plant?

    @State private var name = ""
    @State private var type: PlantType = .rose
    @State private var moisture: Double = 50
    @State private var light: Double = 50

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                TextField("Назва рослини", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Picker("Тип рослини", selection: $type) {
                    ForEach(PlantType.allCases) { plantType in
                        Text(plantType.rawValue).tag(plantType)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                VStack(alignment: .leading) {
                    Text("Вологість ґрунту: \(Int(moisture))%")
                        .font(.subheadline)
                    Slider(value: $moisture, in: 0...100, step: 1)
                }
                .padding(.horizontal)

                VStack(alignment: .leading) {
                    Text("Освітленість: \(Int(light))%")
                        .font(.subheadline)
                    Slider(value: $light, in: 0...100, step: 1)
                }
                .padding(.horizontal)

                Button(action: {
                    let updatedPlant = Plant(
                        id: plantToEdit?.id ?? UUID().uuidString,
                        name: name,
                        type: type,
                        moistureLevel: Int(moisture),
                        lightLevel: Int(light)
                    )

                    if plantToEdit != nil {
                        viewModel.updatePlant(updatedPlant, userId: userId)
                    } else {
                        viewModel.addPlant(
                            name: updatedPlant.name,
                            type: updatedPlant.type,
                            moisture: updatedPlant.moistureLevel,
                            light: updatedPlant.lightLevel,
                            userId: userId
                        )
                    }

                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(plantToEdit == nil ? "Додати" : "Оновити")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding()

                Spacer()
            }
            .navigationTitle(plantToEdit == nil ? "Нова рослина" : "Редагування")
            .onAppear {
                if let plant = plantToEdit {
                    name = plant.name
                    type = plant.type
                    moisture = Double(plant.moistureLevel)
                    light = Double(plant.lightLevel)
                }
            }
        }
    }
}
