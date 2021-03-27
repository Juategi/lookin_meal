# lookin_meal

TODO
EN BUSQUEDA UNICA NO GUARDAR EL DISHQUERY,

el horario llega mal,
quitar primeros frames authenticate al iniciar (future delayed),
j@j.j da error al registrar
while en login por si hay dc,
Terminar busqueda platos compleja, menos exacta,
arreglar cuadros texto
actualizar pagina inicial despues de cambiar ubi (replantear el tema ubi)
hacer trim() en la busqueda da error
listener en nombre y tipos de restaurante para los tiles (quizas inecesario solo lo ve el owner)
sistema de cancelacion de reservas y dias cerrado
share y aviso de conexion
sistema actualizacion


https://developers.google.com/maps/documentation/android-sdk/get-api-key#restrict_key


 DBServiceUser.dbServiceUser.addNotification(PersonalNotification(
                                   restaurant_name: restaurant.name,
                                   restaurant_id: restaurant.restaurant_id,
                                   user_id: reservation.user_id,
                                   type: "Reserv",
                                   body: "Reservation cancelled from restaurant " + restaurant.name
                                 ));
