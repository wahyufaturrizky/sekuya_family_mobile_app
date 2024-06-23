// To parse this JSON data, do
//
//     final missionResponseModel = missionResponseModelFromJson(jsonString);

class MissionResponseModel {
  final Data? data;
  final String? message;
  final int? statusCode;

  MissionResponseModel({
    this.data,
    this.message,
    this.statusCode,
  });

  factory MissionResponseModel.fromJson(Map<String, dynamic> json) => MissionResponseModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "message": message,
        "statusCode": statusCode,
      };
}

class Data {
  final List<Datum>? data;
  final Meta? meta;

  Data({
    this.data,
    this.meta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "meta": meta?.toJson(),
      };
}

class Datum {
  final String? id;
  final String? communityId;
  final String? name;
  final String? description;
  final List<Reward>? rewards;
  final List<Task>? tasks;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isPublished;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final DatumCommunity? community;
  final DatumStatus? status;
  final int? totalTasks;
  final int? totalPlayers;
  final double? totalExp;
  final List<PlayerSample>? playerSamples;

  Datum({
    this.id,
    this.communityId,
    this.name,
    this.description,
    this.rewards,
    this.tasks,
    this.startDate,
    this.endDate,
    this.isPublished,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.community,
    this.status,
    this.totalTasks,
    this.totalPlayers,
    this.totalExp,
    this.playerSamples,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        communityId: json["communityId"],
        name: json["name"],
        description: json["description"],
        rewards: json["rewards"] == null ? [] : List<Reward>.from(json["rewards"]!.map((x) => Reward.fromJson(x))),
        tasks: json["tasks"] == null ? [] : List<Task>.from(json["tasks"]!.map((x) => Task.fromJson(x))),
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        isPublished: json["isPublished"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        community: json["community"] == null ? null : DatumCommunity.fromJson(json["community"]),
        status: datumStatusValues.map[json["status"]]!,
        totalTasks: json["totalTasks"],
        totalPlayers: json["totalPlayers"],
        totalExp: json["totalExp"]?.toDouble(),
        playerSamples: json["playerSamples"] == null ? [] : List<PlayerSample>.from(json["playerSamples"]!.map((x) => PlayerSample.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "communityId": communityId,
        "name": name,
        "description": description,
        "rewards": rewards == null ? [] : List<dynamic>.from(rewards!.map((x) => x.toJson())),
        "tasks": tasks == null ? [] : List<dynamic>.from(tasks!.map((x) => x.toJson())),
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "isPublished": isPublished,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "community": community?.toJson(),
        "status": datumStatusValues.reverse[status],
        "totalTasks": totalTasks,
        "totalPlayers": totalPlayers,
        "totalExp": totalExp,
        "playerSamples": playerSamples == null ? [] : List<dynamic>.from(playerSamples!.map((x) => x.toJson())),
      };
}

class DatumCommunity {
  final String? id;
  final Name? name;
  final String? description;
  final String? image;
  final String? coverImage;
  final Social? social;
  final int? exp;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  DatumCommunity({
    this.id,
    this.name,
    this.description,
    this.image,
    this.coverImage,
    this.social,
    this.exp,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory DatumCommunity.fromJson(Map<String, dynamic> json) => DatumCommunity(
        id: json["_id"],
        name: nameValues.map[json["name"]]!,
        description: json["description"],
        image: json["image"],
        coverImage: json["coverImage"],
        social: json["social"] == null ? null : Social.fromJson(json["social"]),
        exp: json["exp"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": nameValues.reverse[name],
        "description": description,
        "image": image,
        "coverImage": coverImage,
        "social": social?.toJson(),
        "exp": exp,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

enum Name { CVB, CVBCVB, NFT_COMMUNITY }

final nameValues = EnumValues({"cvb": Name.CVB, "cvbcvb": Name.CVBCVB, "NFT Community": Name.NFT_COMMUNITY});

class Social {
  final String? discord;
  final String? twitter;
  final String? instagram;
  final String? facebook;

  Social({
    this.discord,
    this.twitter,
    this.instagram,
    this.facebook,
  });

  factory Social.fromJson(Map<String, dynamic> json) => Social(
        discord: json["discord"],
        twitter: json["twitter"],
        instagram: json["instagram"],
        facebook: json["facebook"],
      );

  Map<String, dynamic> toJson() => {
        "discord": discord,
        "twitter": twitter,
        "instagram": instagram,
        "facebook": facebook,
      };
}

class PlayerSample {
  final LinkedAccount? linkedAccount;
  final String? id;
  final String? oauthId;
  final String? email;
  final String? username;
  final String? profilePic;
  final String? walletAddress;
  final int? exp;
  final String? fcmToken;
  final String? recoveryEmail;
  final List<CommunityElement>? communities;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  PlayerSample({
    this.linkedAccount,
    this.id,
    this.oauthId,
    this.email,
    this.username,
    this.profilePic,
    this.walletAddress,
    this.exp,
    this.fcmToken,
    this.recoveryEmail,
    this.communities,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory PlayerSample.fromJson(Map<String, dynamic> json) => PlayerSample(
        linkedAccount: json["linkedAccount"] == null ? null : LinkedAccount.fromJson(json["linkedAccount"]),
        id: json["_id"],
        oauthId: json["oauthId"],
        email: json["email"],
        username: json["username"],
        profilePic: json["profilePic"],
        walletAddress: json["walletAddress"],
        exp: json["exp"],
        fcmToken: json["fcmToken"],
        recoveryEmail: json["recoveryEmail"],
        communities: json["communities"] == null ? [] : List<CommunityElement>.from(json["communities"]!.map((x) => CommunityElement.fromJson(x))),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "linkedAccount": linkedAccount?.toJson(),
        "_id": id,
        "oauthId": oauthId,
        "email": email,
        "username": username,
        "profilePic": profilePic,
        "walletAddress": walletAddress,
        "exp": exp,
        "fcmToken": fcmToken,
        "recoveryEmail": recoveryEmail,
        "communities": communities == null ? [] : List<dynamic>.from(communities!.map((x) => x.toJson())),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class CommunityElement {
  final String? communityId;
  final int? exp;
  final String? id;

  CommunityElement({
    this.communityId,
    this.exp,
    this.id,
  });

  factory CommunityElement.fromJson(Map<String, dynamic> json) => CommunityElement(
        communityId: json["communityId"],
        exp: json["exp"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "communityId": communityId,
        "exp": exp,
        "_id": id,
      };
}

class LinkedAccount {
  final String? discord;
  final String? telegram;
  final String? twitter;

  LinkedAccount({
    this.discord,
    this.telegram,
    this.twitter,
  });

  factory LinkedAccount.fromJson(Map<String, dynamic> json) => LinkedAccount(
        discord: json["discord"],
        telegram: json["telegram"],
        twitter: json["twitter"],
      );

  Map<String, dynamic> toJson() => {
        "discord": discord,
        "telegram": telegram,
        "twitter": twitter,
      };
}

class Reward {
  final String? id;
  final String? name;
  final String? description;
  final String? image;
  final int? maxQty;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Reward({
    this.id,
    this.name,
    this.description,
    this.image,
    this.maxQty,
    this.createdAt,
    this.updatedAt,
  });

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        maxQty: json["maxQty"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image": image,
        "maxQty": maxQty,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

enum DatumStatus { COMPLETED, ON_GOING }

final datumStatusValues = EnumValues({"Completed": DatumStatus.COMPLETED, "On Going": DatumStatus.ON_GOING});

class Task {
  final String? id;
  final String? name;
  final String? description;
  final String? taskCategoryKey;
  final AdditionalAttribute? additionalAttribute;
  final double? exp;
  final String? image;
  final String? imageProof;
  final TaskStatus? status;
  final String? reason;
  final String? submittedAdditionalAttribute;

  Task({
    this.id,
    this.name,
    this.description,
    this.taskCategoryKey,
    this.additionalAttribute,
    this.exp,
    this.image,
    this.imageProof,
    this.status,
    this.reason,
    this.submittedAdditionalAttribute,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        taskCategoryKey: json["taskCategoryKey"],
        additionalAttribute: json["additionalAttribute"] == null ? null : AdditionalAttribute.fromJson(json["additionalAttribute"]),
        exp: json["exp"]?.toDouble(),
        image: json["image"],
        imageProof: json["imageProof"],
        status: taskStatusValues.map[json["status"]]!,
        reason: json["reason"],
        submittedAdditionalAttribute: json["submittedAdditionalAttribute"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "taskCategoryKey": taskCategoryKey,
        "additionalAttribute": additionalAttribute?.toJson(),
        "exp": exp,
        "image": image,
        "imageProof": imageProof,
        "status": taskStatusValues.reverse[status],
        "reason": reason,
        "submittedAdditionalAttribute": submittedAdditionalAttribute,
      };
}

class AdditionalAttribute {
  final String? link;
  final List<String>? question;

  AdditionalAttribute({
    this.link,
    this.question,
  });

  factory AdditionalAttribute.fromJson(Map<String, dynamic> json) => AdditionalAttribute(
        link: json["link"],
        question: json["question"] == null ? [] : List<String>.from(json["question"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "link": link,
        "question": question == null ? [] : List<dynamic>.from(question!.map((x) => x)),
      };
}

enum TaskStatus { APPROVED, NOT_SUBMITTED }

final taskStatusValues = EnumValues({"APPROVED": TaskStatus.APPROVED, "NOT_SUBMITTED": TaskStatus.NOT_SUBMITTED});

class Meta {
  final int? page;
  final int? limit;
  final int? totalPages;
  final int? totalResults;

  Meta({
    this.page,
    this.limit,
    this.totalPages,
    this.totalResults,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        totalResults: json["totalResults"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
        "totalResults": totalResults,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
