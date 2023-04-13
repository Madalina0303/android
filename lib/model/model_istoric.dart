class IstoricModel {
  int user_id = 0;
  String centru = 'Centrul de transfuzii Iasi';
  String tip = 'sange';
  String data = "2022-03-03";
  String brat = 'dreapta';

  IstoricModel(this.user_id, this.centru, this.tip, this.data, this.brat);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_id': user_id,
      'centru': centru,
      'tip': tip,
      'data': data,
      'brat': brat
    };
    return map;
  }

  IstoricModel.fromMap(Map<String, dynamic> map) {
    user_id = map['user_id'];
    centru = map['centru'];
    tip = map['tip'];
    data = map['data'];
    brat = map['brat'];
  }
}
