import SwiftUI

struct HeaderFormSection: View {
    @Bindable var viewModel: ChecklistViewModel

    var body: some View {
        Section("Datos generales") {
            Picker("Movimiento", selection: $viewModel.movement) {
                ForEach(MovementType.allCases) { movement in
                    Text(movement.displayName).tag(movement)
                }
            }
            .pickerStyle(.segmented)

            LabeledContent("Fecha") {
                Text(viewModel.date, format: .dateTime.day().month(.wide).year())
            }
            LabeledTextField(label: "Proyecto", prompt: "Nombre del proyecto", text: $viewModel.project)
            LabeledTextField(label: "Destino", prompt: "Lugar de trabajo", text: $viewModel.destination)
            LabeledTextField(label: "Elaborado por", prompt: "Nombre y apellido", text: $viewModel.preparedBy)
                .textContentType(.name)
            LabeledTextField(label: "Acompañantes", prompt: "Opcional", text: $viewModel.companions)
        }
    }
}

private struct LabeledTextField: View {
    let label: String
    let prompt: String
    @Binding var text: String

    var body: some View {
        LabeledContent(label) {
            TextField(label, text: $text, prompt: Text(prompt))
                .multilineTextAlignment(.trailing)
        }
    }
}
