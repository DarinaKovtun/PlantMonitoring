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
    @State private var moistureThreshold: Double = 30
    @State private var lightThreshold: Double = 40

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

                // ➕ Пороги вологості та освітленості
                VStack(alignment: .leading) {
                    Text("Поріг вологості: \(Int(moistureThreshold))%")
                        .font(.subheadline)
                    Slider(value: $moistureThreshold, in: 10...80, step: 1)
                }
                .padding(.horizontal)

                VStack(alignment: .leading) {
                    Text("Поріг освітленості: \(Int(lightThreshold))%")
                        .font(.subheadline)
                    Slider(value: $lightThreshold, in: 10...100, step: 1)
                }
                .padding(.horizontal)

                Button(action: {
                    let plant = Plant(
                        id: plantToEdit?.id ?? UUID().uuidString,
                        name: name,
                        type: type,
                        moistureLevel: Int(moisture),
                        lightLevel: Int(light),
                        moistureThreshold: Int(moistureThreshold),
                        lightThreshold: Int(lightThreshold)
                    )

                    if plantToEdit != nil {
                        viewModel.updatePlant(plant, userId: userId)
                    } else {
                        viewModel.addPlant(
                            plant,
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
                    moistureThreshold = Double(plant.moistureThreshold)
                    lightThreshold = Double(plant.lightThreshold)
                }
            }
        }
    }
}
