class EventModel {
  int? idEvento;
  String? descEvento;
  String? fechaEvento;
  bool? completado;

  EventModel(
      {this.idEvento, this.descEvento, this.fechaEvento, this.completado});
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      idEvento: map['idEvento'],
      descEvento: map['descEvento'],
      fechaEvento: map['fechaEvento'],
      completado: map['completado'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idEvento': idEvento,
      'descEvento': descEvento,
      'fechaEvento': fechaEvento,
      'completado': completado == true ? 1 : 0,
    };
  }
}
