import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pmsna/database/database_helper.dart';
import 'package:pmsna/models/event_model.dart';
import 'package:pmsna/provider/flags_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Eventos extends StatefulWidget {
  const Eventos({super.key});

  @override
  State<Eventos> createState() => _EventosState();
}

class _EventosState extends State<Eventos> with TickerProviderStateMixin {
  CalendarView _calendarView = CalendarView.month;
  Key _calendarKey = UniqueKey();

  DatabaseHelper? databaseHelper;

  List<EventModel> _eventModel = [];

  DateTime? _selectedDate;

  TextEditingController _controller = TextEditingController();

  int? _selectedEventId;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    _recuperaEventos();
    _selectedDate = DateTime.now();
  }

  void _recuperaEventos() async {
    List<EventModel> eventModel = await databaseHelper!.getAllEventos();
    setState(() {
      _eventModel = eventModel;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlagsProvider flag = Provider.of<FlagsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis LinceEventos',
            style: Theme.of(context).textTheme.bodyLarge),
        actions: [
          ToggleButtons(
            children: [
              Icon(Icons.calendar_month),
              Icon(Icons.list),
            ],
            isSelected: [
              _calendarView == CalendarView.month,
              _calendarView == CalendarView.schedule,
            ],
            onPressed: (index) {
              setState(() {
                if (index == 0) {
                  _calendarView = CalendarView.month;
                  _calendarKey = UniqueKey();
                } else if (index == 1) {
                  _calendarView = CalendarView.schedule;
                  _calendarKey = UniqueKey();
                }
              });
            },
          ),
        ],
      ),
      body: SfCalendar(
        key: _calendarKey,
        view: _calendarView,
        dataSource: _DataSourse(_eventModel),
        onTap: (calendarTapDetails) async {
          if (calendarTapDetails.targetElement ==
              CalendarElement.calendarCell) {
            setState(() {
              _selectedDate = calendarTapDetails.date;
            });
          } else if (calendarTapDetails.targetElement ==
              CalendarElement.appointment) {
            MyAppointment appointment =
                calendarTapDetails.appointments![0] as MyAppointment;
            _showDetailsEvent(appointment, flag);
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showDialog(context, flag);
        },
        label: const Text('Agrega LinceEvento'),
        icon: const Icon(Icons.add),
      ),
    );
  } //cierre del primer future

  Future<dynamic> _showDialog(BuildContext context, FlagsProvider flag) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Crear LinceEvento',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              content: Text(
                '¿Desea crear un evento para la fecha: ${DateFormat.yMMMMd().format(_selectedDate!)}?',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showAddEventDialog(context, flag);
                    },
                    child: Text('Aceptar')),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar')),
              ],
            );
          },
        );
      },
    );
  } //cierre del segundo future

  Future<dynamic> _showAddEventDialog(
      BuildContext context, FlagsProvider flag) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Agregar LinceEvento :D',
                style: Theme.of(context).textTheme.bodyLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Fecha para el LinceEvento: ${DateFormat.yMMMMd().format(_selectedDate!)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration:
                      InputDecoration(labelText: 'Descripcion del LinceEvento'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese la desripcion del LinceEvento';
                    }
                    return null;
                  },
                  controller: _controller,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (_controller.text.isNotEmpty) {
                            final event = EventModel(
                                descEvento: _controller.text,
                                fechaEvento: _selectedDate!.toIso8601String(),
                                completado: false);
                            await databaseHelper!
                                .INSERT('tblEvento', event.toMap());

                            _controller.clear();
                            Navigator.pop(context);
                            _recuperaEventos();
                            setState(() {});
                            flag.setflagListPost();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('LinceEvento añadido')),
                            );
                          }
                        },
                        child: Text(
                          'Agregar LinceEvento',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancelar',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ))
                  ],
                ),
              ],
            ),
          );
        });
  } //cierre de otro future

  Future<void> _deleteEvento(int idInterfaz) async {
    await databaseHelper!.DELETE('tblEvento', idInterfaz, 'idEvento');
    setState(() {
      _eventModel.removeWhere((event) => event.idEvento == idInterfaz);
    });
  }

  void _showDetailsEvent(MyAppointment appointment, FlagsProvider flag) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Detalles del LinceEvento',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Descripcion: ${appointment.subject}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Fecha: ${DateFormat.yMMMMd().format(appointment.startTime)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          eventoCompletado(appointment);
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.check),
                        label: Text('Completar :D')),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          showUpdateEvent(appointment, flag);
                        },
                        icon: Icon(Icons.update),
                        label: Text('Actualizar')),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          showDeleteEvent(appointment, flag);
                        },
                        icon: Icon(Icons.delete),
                        label: Text('Eliminar'))
                  ],
                )
              ],
            )),
          );
        });
  }

  //--------------metodos jejeje
  void eventoCompletado(MyAppointment appointment) async {
    await databaseHelper!.UPDATE(
        'tblEvento',
        {
          'idEvento': appointment.idEvento,
          'descEvento': appointment.subject,
          'fechaEvento': !appointment.completado,
        },
        'idEvento');
    int index = _eventModel.indexWhere(
      (e) => e.idEvento == appointment.idEvento,
    );
    _eventModel[index].completado = !appointment.completado;

    setState(() {});
  }

  //---otro metodo
  void showUpdateEvent(MyAppointment appointment, FlagsProvider flag) {
    DateTime dateEvent = appointment.startTime;
    String descEvent = appointment.subject;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Editar LinceEvento',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                'Actualizar LinceEvento',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fecha: ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    DateFormat.yMMMMd().format(dateEvent),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  IconButton(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: dateEvent,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        if (pickedDate != null && pickedDate != dateEvent) {
                          setState(() {
                            dateEvent = pickedDate;
                          });
                        }
                      },
                      icon: Icon(Icons.calendar_today))
                ],
              ),
              SizedBox(height: 16.0),
              TextField(
                style: Theme.of(context).textTheme.bodyLarge,
                decoration:
                    InputDecoration(labelText: 'Descripcion del LinceEvento'),
                onChanged: (value) {
                  descEvent = value;
                },
                controller: TextEditingController(text: descEvent),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                      onPressed: () async {
                        await databaseHelper!.UPDATE(
                            'tblEvento',
                            {
                              'idEvento': appointment.idEvento,
                              'descEvento': descEvent,
                              'fechaEvento': dateEvent.toIso8601String(),
                              'completado': appointment.completado
                            },
                            'idEvento');
                        setState(() {
                          appointment.subject = descEvent;
                          appointment.startTime = dateEvent;
                          appointment.endTime = dateEvent;
                        });
                        Navigator.pop(context);
                        _recuperaEventos();
                        flag.setflagListPost();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Cambios guardados')),
                        );
                      },
                      icon: Icon(Icons.save),
                      label: Text('Guardar cambios')),
                  ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.cancel),
                      label: Text('Cancelar'))
                ],
              )
            ]),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          );
        });
  }

  //--------------otro metodo
  void showDeleteEvent(MyAppointment appointment, FlagsProvider flag) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Eliminar LinceEvento',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          content: Text(
            '¿Estas seguro que deseas eliminar este LinceEvento?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  await databaseHelper!
                      .DELETE('tblEvento', appointment.idEvento, 'idEvento');
                  Navigator.pop(context);
                  _recuperaEventos();
                  flag.setflagListPost();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('LinceEvento eliminado')));
                },
                child: Text('Eliminar')),
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'))
          ],
        );
      },
    );
  }
}

//------metodo  datasourse
class _DataSourse extends CalendarDataSource {
  _DataSourse(List<EventModel> eventModel) {
    appointments = eventModel.map((event) {
      DateTime dateTime = DateTime.parse(event.fechaEvento!);
      final DateTime today = DateTime.now();
      final DateTime twoDayAhead = today.add(Duration(days: 2));
      Color color;

      if (isToday(dateTime)) {
        color = Colors.green;
      } else if (dateTime.isBefore(DateTime.now()) &&
          event.completado! == true) {
        color = Colors.green;
      } else if (dateTime.isBefore(DateTime.now()) &&
          event.completado! == false) {
        color = Colors.red;
      } else if (dateTime.difference(DateTime.now()).inDays < 2) {
        color = Colors.yellow;
      } else {
        color = Colors.blue;
      }

      return MyAppointment(
          startTime: dateTime,
          endTime: dateTime,
          subject: event.descEvento!,
          isAllDay: true,
          color: color,
          completado: event.completado ?? false,
          idEvento: event.idEvento!);
    }).toList();
  }
  //---otro metodo
  bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }
} //cierre de clase

//---otra clase
class MyAppointment extends Appointment {
  bool completado;
  int idEvento;
  MyAppointment(
      {required DateTime startTime,
      required DateTime endTime,
      required String subject,
      bool isAllDay = false,
      Color? color,
      this.completado = false,
      required this.idEvento})
      : super(
          startTime: startTime,
          endTime: endTime,
          subject: subject,
          isAllDay: isAllDay,
          color: color!,
        );
}
