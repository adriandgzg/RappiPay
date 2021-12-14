## Instalación 

```bash
pod install
```


# Componentes

- Capa de Red(Networking)

- Capa de BD (Ofline Modes)

- Capa de Repositorios (manejo de Red así como de consultas ofline)

- Capa de Vistas con [VIPER](https://www.objc.io/issues/13-architecture/viper/)

    HomeView - ( View-Interactor-Presentes-Entities-Router)
    DetailMovie - (View - Router)





## Uso

Despues de instalar los pods correspondientes, abrir RappiTestMovieCatalog

## Respuestas

1. En qué consiste el principio de responsabilidad única? Cuál es su propósito?
   El principio de responsabilidad única es una forma de trabajar en el que se busca que todas las clases que se creen, tengan una sola responsabilidad y buscar el menor acoplamiento entre clases, esto permite tener código mas mantenible, limpio y facil de aprender (entender)


2. Qué características tiene, según su opinión, un “buen” código o código limpio

un buen código, debe estar preparado con diversos metodos de trabajo o "normas" para poder estar preparado a los cambios, para poder trabajar de manera sincronizada con un equipo grande y no tener conflictos o embudos (cuellos de botellas) para poder trabajar, debe ser facil de testear y que el performance se pueda medir, esto permitira que los cambios se hagan de manera mas sencilla, que puedan definirse nuevos cambios sin tener que refactorizar códigos que no fueron planeados bien, que en un punto permita ahorrar recursos económicos ante los cambios con nuevas funcionalidades creadas asi como los cambios de módulos ya realizados. 
un código limpio permite crecer de mejor manera, dar mantenimientos mas rapidos, tener menos errores, poder hasta diagnosticar bugs de mejor manera.
 
