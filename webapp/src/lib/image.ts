/**
 * Shrinks a photo to at most `size`×`size` and re-encodes it as JPEG, so
 * profile pictures upload quickly even from a phone camera.
 */
export async function resizeImage(file: File, size = 512): Promise<Blob> {
  const bitmap = await createImageBitmap(file)
  const scale = Math.min(1, size / Math.max(bitmap.width, bitmap.height))
  const canvas = document.createElement("canvas")
  canvas.width = Math.round(bitmap.width * scale)
  canvas.height = Math.round(bitmap.height * scale)
  canvas.getContext("2d")!.drawImage(bitmap, 0, 0, canvas.width, canvas.height)
  return new Promise((resolve, reject) =>
    canvas.toBlob(
      (blob) => (blob ? resolve(blob) : reject(new Error("Could not read image"))),
      "image/jpeg",
      0.85,
    ),
  )
}
