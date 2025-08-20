import 'package:objectbox/objectbox.dart';

@Entity()
@Property(uid: 8124089256188265815)
class EmployeeDetails {
   @Id()
  int id = 0;
	String? sId;
	String? bloodGroup;
	String? createdBy;
	String? createdOn;
	String? dob;
	String? employmentType;
	String? hierarchyId;
	String? mobileNo;
	String? name;
	String? status;
	String? supervisorId;
	String? tradeType;
  @Unique()
  String? labourId;
  String? faceEmbedding;
  DateTime? createdDate;

	EmployeeDetails({this.sId,this.faceEmbedding,this.labourId, this.createdDate ,this.bloodGroup, this.createdBy, this.createdOn, this.dob, this.employmentType, this.hierarchyId, this.mobileNo, this.name, this.status, this.supervisorId, this.tradeType});

	EmployeeDetails.fromJson(Map<String, dynamic> json) {
		sId = json['_id'];
		bloodGroup = json['blood_group'];
		createdBy = json['created_by'];
		createdOn = json['created_on'];
		dob = json['dob'];
		employmentType = json['employment_type'];
		hierarchyId = json['hierarchy_id'];
		mobileNo = json['mobile_no'];
		name = json['name'];
		status = json['status'];
		supervisorId = json['supervisor_id'];
		tradeType = json['trade_type'];
    faceEmbedding = json["faceEmbedding"];
    labourId = json["_id"];
    createdDate = json["created_on"];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data =  <String, dynamic>{};
		data['_id'] = sId;
		data['blood_group'] = bloodGroup;
		data['created_by'] = createdBy;
		data['created_on'] = createdOn;
		data['dob'] = dob;
		data['employment_type'] = employmentType;
		data['hierarchy_id'] = hierarchyId;
		data['mobile_no'] = mobileNo;
		data['name'] = name;
		data['status'] = status;
		data['supervisor_id'] = supervisorId;
		data['trade_type'] = tradeType;
		return data;
	}
}

