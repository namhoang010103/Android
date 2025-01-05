class ShowtimeModel {
  final String date; // Ngày chiếu
  final List<String> time; // Danh sách giờ chiếu

  ShowtimeModel({
    required this.date,
    required this.time,
  });

  // Chuyển từ Firestore sang ShowtimeModel
  factory ShowtimeModel.fromFirestore(Map<String, dynamic> data) {
    return ShowtimeModel(
      date: data['date'] ?? '',
      time: List<String>.from(data['time'] ?? []),
    );
  }

  // Chuyển từ ShowtimeModel sang Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'date': date,
      'time': time,
    };
  }
}

class SeatModel {
  final String id; // ID ghế (VD: A1, B2)
  final String status; // Trạng thái: available, reserved, selected

  SeatModel({
    required this.id,
    required this.status,
  });

  // Chuyển từ Firestore sang SeatModel
  factory SeatModel.fromFirestore(Map<String, dynamic> data) {
    return SeatModel(
      id: data['id'] ?? '',
      status: data['status'] ?? 'available',
    );
  }

  // Chuyển từ SeatModel sang Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'status': status,
    };
  }
}
