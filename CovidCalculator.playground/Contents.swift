enum Country : String {
    case Argentina = "Argentina"
    case Bolivia = "Bolivia"
    case Canada = "Canada"
    case UnitedStates = "United States"
}

struct CovidCases {
    var country: Country
    var numbers: UInt64
}

class BaseCalculator {
    var covidCase: CovidCases = CovidCases(country: .UnitedStates, numbers: 0)

    init(country: Country) {
        self.covidCase.country = country
        self.covidCase.numbers = 0
    }
    
    func calculateCovidCases(_ handler: (CovidCases) -> Void) {
        var numbers: UInt64 = 0
        covidCase.numbers = numbers
        
        handler(covidCase)
    }
}

class ArgentinaCalculator: BaseCalculator {
    
    init() {
        super.init(country: .Argentina)
    }
    
    override func calculateCovidCases(_ handler: (CovidCases) -> Void) {
        var numbers: UInt64 = 100
        // Add covid cases in Argentina
        
        covidCase.numbers = numbers
        
        handler(covidCase)
    }
}

class BoliviaCalculator: BaseCalculator {
    
    init() {
        super.init(country: .Bolivia)
    }
    
    override func calculateCovidCases(_ handler: (CovidCases) -> Void) {
        var numbers: UInt64 = 200
        // Add covid cases in Bolivia
        
        covidCase.numbers = numbers
        
        handler(covidCase)
    }
}

class CanadaCalculator: BaseCalculator {
    
    init() {
        super.init(country: .Canada)
    }
    
    override func calculateCovidCases(_ handler: (CovidCases) -> Void) {
        var numbers: UInt64 = 300
        // Add covid cases in Canada
        
        covidCase.numbers = numbers
        
        handler(covidCase)
    }
}

class USCalculator: BaseCalculator {
    
    init() {
        super.init(country: .UnitedStates)
    }
    
    override func calculateCovidCases(_ handler: (CovidCases) -> Void) {
        var numbers: UInt64 = 400
        // Add covid cases in United States
        
        covidCase.numbers = numbers
        
        handler(covidCase)
    }
}

class TotalCasesCalculator {
    
    private func calculatorList(_ countries: [Country]) -> [BaseCalculator] {
        var calculator: [BaseCalculator] = []
        
        for country in countries {
            switch country {
            case .Argentina:
                calculator.append(ArgentinaCalculator())
            case .Bolivia:
                calculator.append(BoliviaCalculator())
            case .Canada:
                calculator.append(CanadaCalculator())
            case .UnitedStates:
                calculator.append(USCalculator())
            default:
                break
            }
        }
        
        return calculator
    }
    
    private func calculateCovidCases(countries: [Country],  completeHandler : ([CovidCases]) -> Void) {
        var worldCovidCases: [CovidCases] = []
        
        for country in calculatorList(countries) {
            country.calculateCovidCases { data in
                worldCovidCases.append(CovidCases(country: data.country, numbers: data.numbers))
                if worldCovidCases.count == countries.count {
                    completeHandler(worldCovidCases)
                }
            }
        }
    }
    
    func worldCovidAnalytics(completeHandler: (UInt64, [CovidCases]) -> Void) {
        calculateCovidCases(countries: [.Argentina, .Bolivia, .Canada, .UnitedStates]) { data in
            let totalCovidCases: UInt64 = data.reduce(0, { $0 + $1.numbers })
            let worldCovidCases = data.sorted { return $0.numbers > $1.numbers }
            
            completeHandler(totalCovidCases, worldCovidCases)
        }
    }
}

var calculator = TotalCasesCalculator()

calculator.worldCovidAnalytics { (total: UInt64, countryCovidCases: [CovidCases]) in
    print("1. Total COVID cases in the world: \(total)")
    
    if let firstCountry = countryCovidCases.first {
        print("2. What’s the country with the most cases and how many cases does it have?")
        print("\(firstCountry.country) : \(firstCountry.numbers)")
    }
    
    print("3. Top 10 of countries and how many cases each has.")
    let count = countryCovidCases.count > 10 ? 10 : countryCovidCases.count
    for item in countryCovidCases[0..<count] {
        print("\(item.country) : \(item.numbers)")
    }
}
