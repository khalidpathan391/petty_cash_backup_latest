class UploadProgress {
  final double progress;
  final int sentBytes;
  final int totalBytes;

  UploadProgress(
    this.progress,
    this.sentBytes,
    this.totalBytes,
  );
}
