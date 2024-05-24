class HelpVar{

//now the actual variables
  String? email;
  String? help;
  String? id;
  String? message;
  String? time;
  String? uid;
  String? status;

  HelpVar({this.email, this.help, this.id, this.message, this.time, this.uid, this.status});

  static HelpVar fromMap(Map<String, dynamic> data) {
    HelpVar help = HelpVar(email: data['email'], help: data['help'], id: data['id'], message: data['message'], time: data['time'], uid: data['uid'], status: data['status']);
    return help;
  }

  Map<String, dynamic> toJson(Map<String, dynamic> data) {
    data['email'] = email;
    data['help'] = help;
    data['id'] = id;
    data['message'] = message;
    data['time'] = time;
    data['uid'] = uid;
    data['status'] = status;
    return data;
  }
}