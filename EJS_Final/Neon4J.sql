/*
Pregunta 3 - Enunciado Neo4j
https://console.neo4j.org

En base a la consigna del punto anterior, pero asumiendo que en este caso se 
pretende modelar el caso con una base de grafos, se sabe que se deberá contar 
con los siguientes componentes:

Nodos principales:
    - Paciente: (Paciente (id, nombre, apellido, fecha_nacimiento, dirección, 
    teléfono, correo, seguro_médico))
    - Doctor: (Doctor (id, nombre, apellido, especialidad, licencia, teléfono, 
    correo))
    - Cita: (Cita (id, fecha, hora, estado))
    - Consulta: (Consulta (id, motivo, diagnóstico, tratamiento))
    - Receta: (Receta (id, fecha_emisión))

Relaciones principales:
    - (Paciente)-[TIENE_CITA]->(Cita)
    - (Cita)-[PROGRAMADA_CON]->(Doctor)
    - (Cita)-[RESULTA_EN]->(Consulta)
    - (Consulta)-[GENERÓ]->(Receta)
    - (Paciente)-[TIENE_CONSULTA]->(Consulta)
    - (Doctor)-[ATENDIÓ]->(Consulta)

1. Crear todos los nodos y relaciones correspondientes al grafo (generar al 
menos un ejemplo de cada cosa)

2. Listar las citas pendientes del paciente con nombre "Juan Pérez"

3. Obtener la lista de pacientes atendidos por la Dra. Ana Gómez

4. Registrar una nueva consulta para "Juan Pérez" realizada por la Dra. 
Ana Gómez con el motivo "Control de presión arterial", diagnóstico 
"Hipertensión controlada" y tratamiento "Continuar medicación"

5. Listar todos los pacientes que hayan tenido alguna cita con un 
cardiólogo o con un neumonólogo
*/
--============================================================================================================
-----------------------------------------------EJERCICIO 1----------------------------------------------------
--============================================================================================================
/* 1. Crear todos los nodos y relaciones correspondientes al grafo (generar al 
menos un ejemplo de cada cosa)

CREATE
(p1:Paciente {id: 'P001', nombre: 'Juan', apellido: 'Pérez', fecha_nacimiento: '1985-05-15', direccion: 'Av. Siempre Viva 123', telefono: '+541155667788', correo: 'juan.perez@email.com', seguro_medico: 'OSDE'}),
(p2:Paciente {id: 'P002', nombre: 'María', apellido: 'García', fecha_nacimiento: '1990-08-22', direccion: 'Calle Falsa 456', telefono: '+541144556677', correo: 'maria.garcia@email.com', seguro_medico: 'Swiss Medical'}),
(p3:Paciente {id: 'P003', nombre: 'Carlos', apellido: 'Rodríguez', fecha_nacimiento: '1978-11-30', direccion: 'Boulevard 789', telefono: '+541133445566', correo: 'carlos.rodriguez@email.com', seguro_medico: 'Galeno'}),
(d1:Doctor {id: 'D001', nombre: 'Ana', apellido: 'Gómez', especialidad: 'Cardiología', licencia: 'LM-45932', telefono: '+541199887766', correo: 'ana.gomez@hospital.com'}),
(d2:Doctor {id: 'D002', nombre: 'Luis', apellido: 'Fernández', especialidad: 'Neumonología', licencia: 'LM-67891', telefono: '+541188776655', correo: 'luis.fernandez@hospital.com'}),
(d3:Doctor {id: 'D003', nombre: 'Laura', apellido: 'Martínez', especialidad: 'Neurología', licencia: 'LM-34567', telefono: '+541177665544', correo: 'laura.martinez@hospital.com'}),
(c1:Cita {id: 'C001', fecha: '2024-03-20', hora: '14:30', estado: 'pendiente'}),
(c2:Cita {id: 'C002', fecha: '2024-03-25', hora: '10:00', estado: 'confirmada'}),
(c3:Cita {id: 'C003', fecha: '2024-04-05', hora: '11:15', estado: 'confirmada'}),
(cons1:Consulta {id: 'CONS001', motivo: 'Control de presión arterial', diagnostico: 'Hipertensión controlada', tratamiento: 'Continuar medicación actual'}),
(cons2:Consulta {id: 'CONS002', motivo: 'Tos persistente', diagnostico: 'Bronquitis aguda', tratamiento: 'Antibióticos y reposo'}),
(r1:Receta {id: 'R001', fecha_emision: '2024-03-20'}),
(r2:Receta {id: 'R002', fecha_emision: '2024-03-25'}),
(p1)-[:TIENE_CITA]->(c1),
(p1)-[:TIENE_CITA]->(c2),
(p2)-[:TIENE_CITA]->(c3),
(c1)-[:PROGRAMADA_CON]->(d1),
(c2)-[:PROGRAMADA_CON]->(d2),
(c3)-[:PROGRAMADA_CON]->(d1),
(c2)-[:RESULTA_EN]->(cons1),
(c3)-[:RESULTA_EN]->(cons2),
(cons1)-[:GENERO]->(r1),
(cons2)-[:GENERO]->(r2),
(p1)-[:TIENE_CONSULTA]->(cons1),
(p2)-[:TIENE_CONSULTA]->(cons2),
(d1)-[:ATENDIO]->(cons1),
(d2)-[:ATENDIO]->(cons2)
*/
--============================================================================================================
-----------------------------------------------EJERCICIO 2----------------------------------------------------
--============================================================================================================
/*2. Listar las citas pendientes del paciente con nombre "Juan Pérez"
MATCH (p:Paciente{nombre:'Juan', apellido:'Pérez'})-[:TIENE_CITA]->(c:Cita{estado:'pendiente'})
RETURN c.id AS id_cita,
       c.fecha AS fecha,
       c.hora AS hora;

*/
--============================================================================================================
-----------------------------------------------EJERCICIO 3----------------------------------------------------
--============================================================================================================
/*3. Obtener la lista de pacientes atendidos por la Dra. Ana Gómez

MATCH (d:Doctor{nombre:'Ana', apellido:'Gómez'})-[:ATENDIO]->(cons:Consulta)<-[:TIENE_CONSULTA]-(p:Paciente)
RETURN p.nombre AS Nombre,
       p.apellido AS Apellido;
*/
--============================================================================================================
-----------------------------------------------EJERCICIO 4----------------------------------------------------
--============================================================================================================
/*4. Registrar una nueva consulta para "Juan Pérez" realizada por la Dra. 
Ana Gómez con el motivo "Control de presión arterial", diagnóstico 
"Hipertensión controlada" y tratamiento "Continuar medicación"

MATCH (p:Paciente{apellido:'Pérez'})
MATCH (d:Doctor{ apellido:'Gómez'})
CREATE (cons3:Consulta {id: 'CONS003', motivo: 'Control de presión arterial', diagnostico: 'Hipertensión controlada', tratamiento: 'Continuar medicación'}),
       (p)-[:TIENE_CONSULTA]->(cons3),
       (d)-[:ATENDIO]->(cons3)
RETURN 'Nueva consulta creada';
*/
--============================================================================================================
-----------------------------------------------EJERCICIO 5----------------------------------------------------
--============================================================================================================
/*5. Listar todos los pacientes que hayan tenido alguna cita con un 
cardiólogo o con un neumonólogo

MATCH (p:Paciente)-[:TIENE_CITA]->(c:Cita)-[:PROGRAMADA_CON]->(d:Doctor)
WHERE d.especialidad IN ['Cardiología', 'Neumonología']
RETURN p.nombre AS Nombre,
       p.apellido AS Apellido,
       d.especialidad AS Atendido_por;
*/
