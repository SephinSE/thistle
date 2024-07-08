String getDepartment(int departmentID) {
  int index = departmentID;
  Map<int, String> departmentMap = {
    0 : 'Select department',
    1 : 'BTech Civil, School of Engineering',
    2 : 'BTech CS, School of Engineering',
    3 : 'BTech EC, School of Engineering',
    4 : 'BTech EEE, School of Engineering',
    5 : 'BTech IT, School of Engineering',
    6 : 'BTech Mech, School of Engineering',
    7 : 'BTech Safety, School of Engineering',
  };
  return departmentMap[index]!;
}

int getDepartmentID(String department) {
  String dep = department;
  Map<int, String> departmentMap = {
    0 : 'Select department',
    1 : 'BTech Civil, School of Engineering',
    2 : 'BTech CS, School of Engineering',
    3 : 'BTech EC, School of Engineering',
    4 : 'BTech EEE, School of Engineering',
    5 : 'BTech IT, School of Engineering',
    6 : 'BTech Mech, School of Engineering',
    7 : 'BTech Safety, School of Engineering',
  };
  return departmentMap.values.toList().indexOf(dep);
}