import Foundation

/// Elementos por ensayo según la hoja "Check-list de ensayos" de Pangea S.R.L.
/// Los códigos de barras son provisorios (prefijo del ensayo + número) hasta tener los reales.
enum TestCatalog {
    struct Entry: Sendable {
        let name: String
        let barcode: String
    }

    static let entries: [TestType: [Entry]] = [
        .sandCone: numbered("CYA", [
            "Cono", "Placa base", "Punta", "Maza", "Pincel",
            "Bolsa", "Arena", "Rodilleras", "Planillas", "Cuchara"
        ]),
        .plateLoad: numbered("PDC", [
            "Placa de carga", "Gato", "Mangueras", "Planillas",
            "Regla", "Flexímetro", "Manómetro", "Aceite"
        ]),
        .dcp: numbered("DCP", [
            "Pesa", "Varilla", "Manija", "Regla", "Planillas", "Pinzas"
        ]),
        .cbr: numbered("CBR", [
            "Molde", "Vástago", "Pesas", "Prensa", "Trípode", "Flexímetro", "Balde p/agua"
        ]),
        .proctorT99: numbered("T99", [
            "Molde T99", "Pisón T99"
        ]),
        .proctorT180: numbered("T180", [
            "Molde T180", "Pisón T180"
        ]),
        .granulometry: numbered("GRA", [
            "Tamiz 3\"", "Tamiz 2\"", "Tamiz 1 1/2\"", "Tamiz 1\"", "Tamiz 3/4\"", "Tamiz 3/8\"",
            "Tamiz Nº4", "Tamiz Nº10", "Tamiz Nº16", "Tamiz Nº40", "Tamiz Nº100", "Tamiz Nº200"
        ]),
        .atterbergLimits: numbered("ATT", [
            "Casagrande", "Acanalador", "Vidrio esmerilado"
        ]),
        .laboratory: numbered("LAB", [
            "Balanza 30 kg (0,1 g)", "Balanza 300 g (0,01 g)", "Espátula", "Bandejas", "Cucharón",
            "Horno", "Bolsas", "Gancho p/balanza", "Canasto p/peso esp."
        ])
    ]

    private static func numbered(_ prefix: String, _ names: [String]) -> [Entry] {
        names.enumerated().map { index, name in
            Entry(name: name, barcode: "\(prefix)-\(String(format: "%02d", index + 1))")
        }
    }
}
