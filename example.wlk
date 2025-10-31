class Nave {
  var velocidad
  var direccionAlSol = 0
  var combustible

  method cargarCombustible(cuanto) {
    combustible += cuanto
  }
  
  method descargarCombustible(cuanto) {
    combustible = 0.max(combustible - cuanto)
  }

  method acelerar(cuanto) {velocidad = 100000.min(velocidad + cuanto)}
  method desacelerar(cuanto) {velocidad = 0.max(velocidad - cuanto)}
  method irHaciaElSol() {direccionAlSol = 10}
  method escaparDelSol() {direccionAlSol = -10}
  method acercarseUnPocoAlSol() {
    direccionAlSol = (direccionAlSol + 1).max(10)
    }  
  method alejarseUnPocoDelSol() {
    direccionAlSol = (direccionAlSol - 1).max(-10)
  }

  method ponerseParaleloAlSol() {
    
  }

  method prepararViaje() {
    self.cargarCombustible(30000)
    self.acelerar(5000)
    self.accionAdicional()
  }

  method accionAdicional() 
  method estaTranquila() {
    return combustible >= 4000 && velocidad <= 12000 && self.condicionAdicional()
  }
  method condicionAdicional() = true

  method recibirAmenaza() {
    self.escapar()
    self.avisar()
  } 

  method escapar()
  method avisar() 

  method estaRelajo() {
    return self.estaTranquila() && self.tienePocaActividad()
  }
  method tienePocaActividad()
}


class NaveBalisa inherits Nave {
  var colorBaliza
  var cambioBaliza = false
  method cambiarColorDeBaliza(colorNuevo) {
    colorBaliza = colorNuevo
    cambioBaliza = true
  } 
  override method accionAdicional() {
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }

  override method condicionAdicional() {
    return colorBaliza <> "rojo"
  }

  override method escapar() {self.irHaciaElSol()}
  override method avisar() {self.cambiarColorDeBaliza("rojo")}

  override method tienePocaActividad() = !cambioBaliza

}

class NavePasajeros inherits Nave {
  const pasajeros
  var comida = 0
  var bebida = 0
  var comidaServida = 0

  method cargar(cantidadBebida, cantidadComida) {
    comida += cantidadComida
    bebida += cantidadBebida
  }
  method descargar(cantidadBebida, cantidadComida) {
    comida = 0.max(comida - cantidadComida)
    bebida = 0.max(bebida - cantidadBebida)
    comidaServida += comida
  }
  override method accionAdicional() {
    self.cargar(6*pasajeros, 4*pasajeros)
    self.acercarseUnPocoAlSol()
  }

  override method escapar() {self.acelerar(velocidad)}
  override method avisar() {self.descargar(2*pasajeros, pasajeros)}
  override method tienePocaActividad() = comidaServida >= 50
}

class NaveDeCombate inherits Nave {
  var visible = true
  var misilesDesplegados = false
  const mensajesEmitidos = []
  method ponerseVisible() {visible = true}
  method ponerseInvisible() {visible = false}
  method estaInvisible() = !visible
  method desplegarMisiles() {misilesDesplegados = true}
  method replegarMisiles() {misilesDesplegados = false}
    method misilesDesplegados() = misilesDesplegados
  method emitirMensaje(unMensaje) {mensajesEmitidos.add(unMensaje)}
  method mensajesEmitidos() = mensajesEmitidos
  method primerMensajeEmitido() { 
    if (mensajesEmitidos.isEmpty()) {
      self.error("Aún no hay mensajes emitidos")
    }
    return mensajesEmitidos.first()
  }
  method ultimoMensajeEmitido() { 
    if (mensajesEmitidos.isEmpty()) {
      self.error("Aún no hay mensajes emitidos")
    }
    return mensajesEmitidos.last()
  }
  method esEscueta() = mensajesEmitidos.all({m => m.length() < 30 })
  method emitioMensaje(unMensaje) = mensajesEmitidos.contains(unMensaje)

  override method accionAdicional() {
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitioMensaje("Saliendo en misión")
  }

  override method condicionAdicional() {
    return !misilesDesplegados
  }

  override method escapar() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }
  override method avisar() {self.emitirMensaje("Amenaza recibida")}
  override method tienePocaActividad() = true
}

class NaveHospital inherits NavePasajeros {
  var quirofanosPreparados = false
  override method condicionAdicional() {
    return !quirofanosPreparados
  }

  method prepararQuirofanos() {
    quirofanosPreparados = true
  }

  override method recibirAmenaza() {
    super()
    self.prepararQuirofanos()
  }
}

class NaveSigilosa inherits NaveDeCombate {
  override method condicionAdicional() {
    return super() && ! self.estaInvisible()
  }

  override method recibirAmenaza() {
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}