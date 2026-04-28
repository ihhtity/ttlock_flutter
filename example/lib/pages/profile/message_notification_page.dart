import 'package:flutter/material.dart';
import '../../theme.dart';

/// 消息通知页面
class MessageNotificationPage extends StatefulWidget {
  const MessageNotificationPage({Key? key}) : super(key: key);

  @override
  _MessageNotificationPageState createState() => _MessageNotificationPageState();
}

class _MessageNotificationPageState extends State<MessageNotificationPage> {
  // 模拟消息数据
  final List<Map<String, dynamic>> _messages = [
    {
      'id': 1,
      'title': '系统通知',
      'content': '欢迎使用宝士力得智能家居系统',
      'time': '2026-04-25 10:30',
      'isRead': false,
      'type': MessageType.system,
    },
    {
      'id': 2,
      'title': '设备提醒',
      'content': '房间101的智能锁电量不足，请及时更换电池',
      'time': '2026-04-25 09:15',
      'isRead': false,
      'type': MessageType.device,
    },
    {
      'id': 3,
      'title': '开锁记录',
      'content': '房间202于 2026-04-25 08:45 被打开',
      'time': '2026-04-25 08:45',
      'isRead': true,
      'type': MessageType.record,
    },
    {
      'id': 4,
      'title': '系统更新',
      'content': '系统已更新至最新版本 v1.0.0',
      'time': '2026-04-24 16:20',
      'isRead': true,
      'type': MessageType.system,
    },
    {
      'id': 5,
      'title': '设备离线',
      'content': '房间302的智能锁已离线，请检查网络连接',
      'time': '2026-04-24 14:10',
      'isRead': true,
      'type': MessageType.device,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('消息通知'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        actions: [
          // 全部已读按钮
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text(
              '全部已读',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: _messages.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageItem(message, index);
              },
            ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            '暂无消息',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建消息项
  Widget _buildMessageItem(Map<String, dynamic> message, int index) {
    final isUnread = !message['isRead'];
    
    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: () => _markAsRead(index),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 消息图标
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getMessageColor(message['type']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getMessageIcon(message['type']),
                  color: _getMessageColor(message['type']),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              
              // 消息内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            message['title'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                              color: const Color(0xFF333333),
                            ),
                          ),
                        ),
                        // 未读标记
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.errorColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      message['content'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message['time'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 标记为已读
  void _markAsRead(int index) {
    setState(() {
      _messages[index]['isRead'] = true;
    });
  }

  /// 全部标记为已读
  void _markAllAsRead() {
    setState(() {
      for (var message in _messages) {
        message['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已全部标记为已读'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  /// 获取消息类型颜色
  Color _getMessageColor(MessageType type) {
    switch (type) {
      case MessageType.system:
        return AppTheme.primaryColor;
      case MessageType.device:
        return AppTheme.warningColor;
      case MessageType.record:
        return AppTheme.successColor;
    }
  }

  /// 获取消息类型图标
  IconData _getMessageIcon(MessageType type) {
    switch (type) {
      case MessageType.system:
        return Icons.info_outline_rounded;
      case MessageType.device:
        return Icons.devices_rounded;
      case MessageType.record:
        return Icons.history_rounded;
    }
  }
}

/// 消息类型
enum MessageType {
  system,   // 系统通知
  device,   // 设备提醒
  record,   // 开锁记录
}
