import 'package:flutter/foundation.dart';
import 'api_client.dart';

/// 设备模型
class DeviceModel {
  final int id;
  final int adminsId;
  final int clientId;
  final int? roomId;
  final int? groupId;
  final String name;
  final String type;
  final String mac;
  final String? model;
  final int status; // 1-在线, 0-离线
  final int battery;
  final String? firmware;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeviceModel({
    required this.id,
    required this.adminsId,
    required this.clientId,
    this.roomId,
    this.groupId,
    required this.name,
    required this.type,
    required this.mac,
    this.model,
    required this.status,
    required this.battery,
    this.firmware,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] ?? 0,
      adminsId: json['admins_id'] ?? 0,
      clientId: json['client_id'] ?? 0,
      roomId: json['room_id'],
      groupId: json['group_id'],
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      mac: json['mac'] ?? '',
      model: json['model'],
      status: json['status'] ?? 0,
      battery: json['battery'] ?? 0,
      firmware: json['firmware'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admins_id': adminsId,
      'client_id': clientId,
      'room_id': roomId,
      'group_id': groupId,
      'name': name,
      'type': type,
      'mac': mac,
      'model': model,
      'status': status,
      'battery': battery,
      'firmware': firmware,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isOnline => status == 1;
  
  String get statusText => isOnline ? '在线' : '离线';
}

/// 房间模型
class RoomModel {
  final int id;
  final int adminsId;
  final int clientId;
  final String name;
  final String? type;
  final String? building;
  final int? floor;
  final String status; // vacant-空置, rented-已租
  final int battery;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoomModel({
    required this.id,
    required this.adminsId,
    required this.clientId,
    required this.name,
    this.type,
    this.building,
    this.floor,
    required this.status,
    required this.battery,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] ?? 0,
      adminsId: json['admins_id'] ?? 0,
      clientId: json['client_id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'],
      building: json['building'],
      floor: json['floor'],
      status: json['status'] ?? 'vacant',
      battery: json['battery'] ?? 100,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admins_id': adminsId,
      'client_id': clientId,
      'name': name,
      'type': type,
      'building': building,
      'floor': floor,
      'status': status,
      'battery': battery,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isVacant => status == 'vacant';
  
  String get statusText => isVacant ? '空置' : '已租';
}

/// 分组模型
class GroupModel {
  final int id;
  final int adminsId;
  final int clientId;
  final String name;
  final String? icon;
  final String? color;
  final int sort;
  final DateTime createdAt;
  final DateTime updatedAt;

  GroupModel({
    required this.id,
    required this.adminsId,
    required this.clientId,
    required this.name,
    this.icon,
    this.color,
    required this.sort,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] ?? 0,
      adminsId: json['admins_id'] ?? 0,
      clientId: json['client_id'] ?? 0,
      name: json['name'] ?? '',
      icon: json['icon'],
      color: json['color'],
      sort: json['sort'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admins_id': adminsId,
      'client_id': clientId,
      'name': name,
      'icon': icon,
      'color': color,
      'sort': sort,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// 分页响应
class PageResponse<T> {
  final int total;
  final int page;
  final int pageSize;
  final List<T> list;

  PageResponse({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.list,
  });

  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final listData = data['list'] as List<dynamic>? ?? [];
    
    return PageResponse(
      total: data['total'] ?? 0,
      page: data['page'] ?? 1,
      pageSize: data['page_size'] ?? 20,
      list: listData.map((item) => fromJson(item as Map<String, dynamic>)).toList(),
    );
  }
}

/// 设备服务
class DeviceService {
  /// 获取设备列表
  static Future<ApiResponse<PageResponse<DeviceModel>>> getDevices({
    int page = 1,
    int pageSize = 20,
    String? type,
    int? status,
    int? roomId,
    int? groupId,
    String? keyword,
  }) async {
    try {
      final queryParameters = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      if (type != null) queryParameters['type'] = type;
      if (status != null) queryParameters['status'] = status.toString();
      if (roomId != null) queryParameters['room_id'] = roomId.toString();
      if (groupId != null) queryParameters['group_id'] = groupId.toString();
      if (keyword != null) queryParameters['keyword'] = keyword;

      final response = await HttpClient.get('/devices', queryParameters: queryParameters);

      if (response.isSuccess && response.data != null) {
        final pageResponse = PageResponse<DeviceModel>.fromJson(
          response.data as Map<String, dynamic>,
          (json) => DeviceModel.fromJson(json),
        );
        
        debugPrint('✅ 获取设备列表成功: ${pageResponse.total}个设备');
        
        return ApiResponse.fromSuccess(pageResponse);
      } else {
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e) {
      debugPrint('❌ 获取设备列表异常: $e');
      return ApiResponse.fromError(500, '获取设备列表失败: $e');
    }
  }

  /// 获取设备详情
  static Future<ApiResponse<DeviceModel>> getDeviceDetail(int deviceId) async {
    try {
      final response = await HttpClient.get('/devices/$deviceId');

      if (response.isSuccess && response.data != null) {
        final device = DeviceModel.fromJson(response.data as Map<String, dynamic>);
        return ApiResponse.fromSuccess(device);
      } else {
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e) {
      return ApiResponse.fromError(500, '获取设备详情失败: $e');
    }
  }

  /// 创建设备
  static Future<ApiResponse> createDevice({
    required String name,
    required String type,
    required String mac,
    String? model,
    int? roomId,
    int? groupId,
  }) async {
    try {
      final response = await HttpClient.post('/devices', body: {
        'name': name,
        'type': type,
        'mac': mac,
        if (model != null) 'model': model,
        if (roomId != null) 'room_id': roomId,
        if (groupId != null) 'group_id': groupId,
      });

      if (response.isSuccess) {
        debugPrint('✅ 创建设备成功');
        return ApiResponse.fromSuccess(null);
      } else {
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e) {
      return ApiResponse.fromError(500, '创建设备失败: $e');
    }
  }

  /// 更新设备
  static Future<ApiResponse> updateDevice(
    int deviceId, {
    String? name,
    int? status,
    int? roomId,
    int? groupId,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (status != null) body['status'] = status;
      if (roomId != null) body['room_id'] = roomId;
      if (groupId != null) body['group_id'] = groupId;

      final response = await HttpClient.put('/devices/$deviceId', body: body);

      if (response.isSuccess) {
        debugPrint('✅ 更新设备成功');
        return ApiResponse.fromSuccess(null);
      } else {
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e) {
      return ApiResponse.fromError(500, '更新设备失败: $e');
    }
  }

  /// 删除设备
  static Future<ApiResponse> deleteDevice(int deviceId) async {
    try {
      final response = await HttpClient.delete('/devices/$deviceId');

      if (response.isSuccess) {
        debugPrint('✅ 删除设备成功');
        return ApiResponse.fromSuccess(null);
      } else {
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e) {
      return ApiResponse.fromError(500, '删除设备失败: $e');
    }
  }
}

/// 房间服务
class RoomService {
  /// 获取房间列表
  static Future<ApiResponse<PageResponse<RoomModel>>> getRooms({
    int page = 1,
    int pageSize = 20,
    String? building,
    int? floor,
    String? status,
    String? keyword,
  }) async {
    try {
      final queryParameters = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      if (building != null) queryParameters['building'] = building;
      if (floor != null) queryParameters['floor'] = floor.toString();
      if (status != null) queryParameters['status'] = status;
      if (keyword != null) queryParameters['keyword'] = keyword;

      final response = await HttpClient.get('/rooms', queryParameters: queryParameters);

      if (response.isSuccess && response.data != null) {
        final pageResponse = PageResponse<RoomModel>.fromJson(
          response.data as Map<String, dynamic>,
          (json) => RoomModel.fromJson(json),
        );
        
        debugPrint('✅ 获取房间列表成功: ${pageResponse.total}个房间');
        
        return ApiResponse.fromSuccess(pageResponse);
      } else {
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e) {
      debugPrint('❌ 获取房间列表异常: $e');
      return ApiResponse.fromError(500, '获取房间列表失败: $e');
    }
  }

  /// 获取房间详情
  static Future<ApiResponse<RoomModel>> getRoomDetail(int roomId) async {
    try {
      final response = await HttpClient.get('/rooms/$roomId');

      if (response.isSuccess && response.data != null) {
        final room = RoomModel.fromJson(response.data as Map<String, dynamic>);
        return ApiResponse.fromSuccess(room);
      } else {
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e) {
      return ApiResponse.fromError(500, '获取房间详情失败: $e');
    }
  }

  /// 创建房间
  static Future<ApiResponse> createRoom({
    required String name,
    String? type,
    String? building,
    int? floor,
  }) async {
    try {
      final response = await HttpClient.post('/rooms', body: {
        'name': name,
        if (type != null) 'type': type,
        if (building != null) 'building': building,
        if (floor != null) 'floor': floor,
      });

      if (response.isSuccess) {
        debugPrint('✅ 创建房间成功');
        return ApiResponse.fromSuccess(null);
      } else {
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e) {
      return ApiResponse.fromError(500, '创建房间失败: $e');
    }
  }

  /// 更新房间
  static Future<ApiResponse> updateRoom(
    int roomId, {
    String? name,
    String? type,
    String? building,
    int? floor,
    String? status,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (type != null) body['type'] = type;
      if (building != null) body['building'] = building;
      if (floor != null) body['floor'] = floor;
      if (status != null) body['status'] = status;

      final response = await HttpClient.put('/rooms/$roomId', body: body);

      if (response.isSuccess) {
        debugPrint('✅ 更新房间成功');
        return ApiResponse.fromSuccess(null);
      } else {
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e) {
      return ApiResponse.fromError(500, '更新房间失败: $e');
    }
  }

  /// 删除房间
  static Future<ApiResponse> deleteRoom(int roomId) async {
    try {
      final response = await HttpClient.delete('/rooms/$roomId');

      if (response.isSuccess) {
        debugPrint('✅ 删除房间成功');
        return ApiResponse.fromSuccess(null);
      } else {
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e) {
      return ApiResponse.fromError(500, '删除房间失败: $e');
    }
  }
}

/// 分组服务
class GroupService {
  /// 获取分组列表
  static Future<ApiResponse<List<GroupModel>>> getGroups() async {
    try {
      final response = await HttpClient.get('/groups');

      if (response.isSuccess && response.data != null) {
        final listData = response.data as List<dynamic>;
        final groups = listData
            .map((item) => GroupModel.fromJson(item as Map<String, dynamic>))
            .toList();
        
        debugPrint('✅ 获取分组列表成功: ${groups.length}个分组');
        
        return ApiResponse.fromSuccess(groups);
      } else {
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e) {
      debugPrint('❌ 获取分组列表异常: $e');
      return ApiResponse.fromError(500, '获取分组列表失败: $e');
    }
  }

  /// 创建分组
  static Future<ApiResponse> createGroup({
    required String name,
    String? icon,
    String? color,
    int sort = 0,
  }) async {
    try {
      final response = await HttpClient.post('/groups', body: {
        'name': name,
        if (icon != null) 'icon': icon,
        if (color != null) 'color': color,
        'sort': sort,
      });

      if (response.isSuccess) {
        debugPrint('✅ 创建分组成功');
        return ApiResponse.fromSuccess(null);
      } else {
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e) {
      return ApiResponse.fromError(500, '创建分组失败: $e');
    }
  }

  /// 更新分组
  static Future<ApiResponse> updateGroup(
    int groupId, {
    String? name,
    String? icon,
    String? color,
    int? sort,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (icon != null) body['icon'] = icon;
      if (color != null) body['color'] = color;
      if (sort != null) body['sort'] = sort;

      final response = await HttpClient.put('/groups/$groupId', body: body);

      if (response.isSuccess) {
        debugPrint('✅ 更新分组成功');
        return ApiResponse.fromSuccess(null);
      } else {
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e) {
      return ApiResponse.fromError(500, '更新分组失败: $e');
    }
  }

  /// 删除分组
  static Future<ApiResponse> deleteGroup(int groupId) async {
    try {
      final response = await HttpClient.delete('/groups/$groupId');

      if (response.isSuccess) {
        debugPrint('✅ 删除分组成功');
        return ApiResponse.fromSuccess(null);
      } else {
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e) {
      return ApiResponse.fromError(500, '删除分组失败: $e');
    }
  }
}
