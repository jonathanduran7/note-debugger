# Note Debugger - App de Gestión de Notas

Una aplicación iOS moderna para gestionar notas con integración completa de **Pulse** para debugging y monitoreo en tiempo real.

## Características Principales

### Gestión de Notas (CRUD)
- ✅ **Crear** notas con título
- ✅ **Leer** lista de notas con búsqueda y ordenamiento
- ✅ **Actualizar** notas existentes
- ✅ **Eliminar** notas con confirmación

## Arquitectura del Proyecto

### Estructura de Archivos
```
note-debugger/
├── note-debugger/
│   ├── note_debuggerApp.swift      # Punto de entrada de la app
│   ├── ContentView.swift           # Vista principal
│   ├── NotesViewModel.swift        # ViewModel con lógica de negocio
│   ├── APIService.swift            # Servicio para API de Supabase
│   ├── Note.swift                  # Modelo de datos
│   ├── ColorPalette.swift          # Paleta de colores
│   ├── NoteCardView.swift          # Componente de tarjeta de nota
│   ├── NoteFormView.swift          # Formulario de crear/editar
│   ├── SearchBarView.swift         # Barra de búsqueda
│   └── SortPickerView.swift        # Selector de ordenamiento
└── README.md                       # Documentación del proyecto
```

### Patrón de Arquitectura
- **MVVM** (Model-View-ViewModel)
- **SwiftUI** para la interfaz de usuario
- **Async/Await** para operaciones asíncronas

## Integración con Pulse

### ¿Qué es Pulse?
**Pulse** es una herramienta de debugging y monitoreo que permite:
- **Monitorear** llamadas de red en tiempo real
- **Inspeccionar** requests y responses
- **Analizar** performance de la aplicación
- **Debuggear** errores de red y API

### Configuración de Pulse

#### 1. Instalación
```swift
// En note_debuggerApp.swift
import SwiftUI
import PulseUI

@main
struct note_debuggerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

#### 2. Integración en ContentView
```swift
import SwiftUI
import PulseUI

struct ContentView: View {
    // ... código existente ...
    
    var body: some View {
        NavigationView {
            // ... contenido principal ...
        }
        // Agregar ConsoleView para debugging
        .sheet(isPresented: $showingPulseConsole) {
            ConsoleView()
        }
    }
}
```

### 📱 Uso de Pulse en el Proyecto

#### 🔍 Monitoreo de API Calls
Pulse captura automáticamente todas las llamadas HTTP realizadas por `URLSession`:

```swift
// APIService.swift - Todas las llamadas son monitoreadas
func fetchNotes() async throws -> [Note] {
    // Esta llamada aparece automáticamente en Pulse
    let (data, response) = try await URLSession.shared.data(for: request)
    // ...
}
```

#### Información Capturada
- **URLs** de todas las requests
- **Headers** enviados y recibidos
- **Bodies** de requests y responses
- **Códigos de estado** HTTP
- **Tiempos de respuesta**
- **Errores** de red y API

#### Beneficios para el Desarrollo
1. **Debugging rápido** de problemas de API
2. **Optimización** de performance de red
3. **Validación** de requests y responses
4. **Monitoreo** en tiempo real durante desarrollo


## Configuración del Proyecto

### Requisitos
- **Xcode** 15.0+
- **iOS** 17.0+
- **Swift** 5.9+

### Instalación
1. Clona el repositorio
2. Abre `note-debugger.xcodeproj` en Xcode
3. Configura tu API key de Supabase en `APIService.swift`
4. Compila y ejecuta en el simulador o dispositivo

### Configuración de Supabase
```swift
// APIService.swift
private let baseURL = "https://your.host/rest/v1"
private let apiKey = "tu-api-key"
```

## Debugging con Pulse

### Acceder a Pulse Console
```swift
// En ContentView, descomenta para habilitar
NavigationLink(destination: ConsoleView()) {
    Text("Console")
}
```

### Información Disponible
- **Network Requests**: Todas las llamadas a la API
- **Responses**: Datos recibidos del servidor
- **Errors**: Errores de red y API
- **Performance**: Tiempos de respuesta
- **Headers**: Información de autenticación y contenido

### Métricas de Performance
- **Response Time**: Tiempo de respuesta de cada request
- **Data Size**: Tamaño de datos transferidos
- **Success Rate**: Porcentaje de requests exitosos
- **Error Analysis**: Análisis de errores comunes

## Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## Contribuciones

Las contribuciones son bienvenidas. Por favor, abre un issue o pull request para sugerencias y mejoras.

---
