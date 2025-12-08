/*Pregunta 2 - Ejercicio MONGODB
Te encuentras participando en el desarrollo de un sistema informático para la gestión de 
consultas médicas en un hospital. El objetivo del sistema es permitir el registro de 
pacientes, la gestión de citas y consultas médicas, así como el seguimiento de diagnósticos 
y recetas. A continuación, se describen los principales actores y sus características.

Actores principales:

Paciente:
    Los pacientes se registran en el hospital para recibir atención médica. Cada paciente debe 
    tener un historial médico único que los identifique y permita a los doctores acceder a sus 
    consultas previas.

    Características del paciente: Nombre, Apellido, Fecha de nacimiento, Dirección, Teléfono, 
    Correo electrónico, Historia clínica.

Doctor:
    Los doctores trabajan en diferentes especialidades dentro del hospital y pueden atender a 
    varios pacientes en un día. Cada doctor debe estar registrado con su nombre, especialidad 
    y un número de licencia médica.

    Características del doctor: Nombre, Apellido, Especialidad, Número de licencia médica, 
    Teléfono, Correo electrónico.

Cita Médica:
    Los pacientes solicitan citas médicas con los doctores. La cita tiene una fecha y hora 
    específica y un estado que indica si la cita está confirmada, pendiente o cancelada.

    Características de la cita: Fecha y hora, Paciente, Doctor, Estado (confirmada, 
    cancelada, pendiente).

Consulta Médica:
    Cuando el paciente asiste a su cita, se genera una consulta médica en la que el doctor 
    registra el motivo de la consulta, el diagnóstico y las recomendaciones de tratamiento.

    Características de la consulta: Fecha y hora, Paciente, Doctor, Motivo de consulta, 
    Diagnóstico, Tratamiento.

Receta Médica:
    Al finalizar la consulta, el doctor puede emitir una receta médica con los 
    medicamentos necesarios para el tratamiento del paciente.

    Características de la receta: Consulta asociada, Fecha de emisión, Detalles 
    de los medicamentos recetados.

1.- Modelar las colecciones y sus respectivos documentos.

2.- Confeccionar una consulta que permita obtener todas las citas médicas pendientes 
del paciente con el ID paciente_123. No mostrar el campo del estado.

3.- Confeccionar una consulta que permita obtener un listado de todos los doctores 
que trabajen en Cardiología o Neurología. Ordenado por Apellido de manera descendente.

4.- Actualizar el estado de la cita cita_001 a "confirmada".

5.- Actualizar la especialidad de todos los Médicos que tengan "Gastroenterología" 
a "Gastro".
*/
--============================================================================================================
-----------------------------------------------EJERCICIO 1----------------------------------------------------
--============================================================================================================
/*1.- Modelar las colecciones y sus respectivos documentos.

// 1. COLECCIONES

// Colección: pacientes
{
  "_id": String,
  "nombre": String,
  "apellido": String,
  "fecha_nacimiento": Date,
  "direccion": String,
  "telefono": String,
  "correo": String,
  "historia_clinica": Array
}

// Colección: doctores
{
  "_id": String,
  "nombre": String,
  "apellido": String,
  "especialidad": String,
  "licencia": String,
  "telefono": String,
  "correo": String
}

// Colección: citas
{
  "_id": String,
  "fecha_y_hora": Date,
  "paciente": {
    "_id": String
  },
  "doctor": {
    "_id": String
  },
  "estado": String // "confirmada", "pendiente", "cancelada"
}

// Colección: consultas (con recetas dentro)
{
  "_id": String,
  "fecha_y_hora": Date,
  "paciente": {
    "_id": String
  },
  "doctor": {
    "_id": String
  },
  "motivo": String,
  "diagnostico": String,
  "tratamiento": String,
  "receta": [
    {
      "emision": Date,
      "medicamento": String
    }
  ]
}
*/
--============================================================================================================
-----------------------------------------------EJERCICIO 2----------------------------------------------------
--============================================================================================================
/*2.- Confeccionar una consulta que permita obtener todas las citas médicas pendientes 
del paciente con el ID paciente_123. No mostrar el campo del estado.

db.citas.find({"paciente._id": "paciente_123", estado: "pendiente"} , {estado: 0})
*/
--============================================================================================================
-----------------------------------------------EJERCICIO 3----------------------------------------------------
--============================================================================================================
/*3.- Confeccionar una consulta que permita obtener un listado de todos los doctores 
que trabajen en Cardiología o Neurología. Ordenado por Apellido de manera descendente.

db.doctores.find(
    {especialidad: {$in: ["Cardiología", "Neurología"]}
    }).sort({apellido: -1})
*/
--============================================================================================================
-----------------------------------------------EJERCICIO 4----------------------------------------------------
--============================================================================================================
/* 4.- Actualizar el estado de la cita cita_001 a "confirmada".

db.citas.updateOne(
    {_id: "cita_001"},
    {$set: {estado: "confirmada"}}
)
*/
--============================================================================================================
-----------------------------------------------EJERCICIO 5----------------------------------------------------
--============================================================================================================
/*5.- Actualizar la especialidad de todos los Médicos que tengan "Gastroenterología" 
a "Gastro".

db.doctores.updateMany(
    {especialidad: "Gastroenterología"},
    {$set: {especialidad: "Gastro"}}
)
*/
