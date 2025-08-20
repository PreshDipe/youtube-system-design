part of 'upload_video_cubit.dart';

@immutable
sealed class UploadVideoState {
  const UploadVideoState();
}

final class UploadVideoInitial extends UploadVideoState {}

final class UploadVideoLoading extends UploadVideoState {}

final class UploadVideoSuccess extends UploadVideoState {}

final class UploadVideoError extends UploadVideoState {
  final String error;
  const UploadVideoError(this.error);
}
