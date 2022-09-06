# jQuery ->
#   $(document).on "upload:start", "form", (e) ->
#     $(this).find("input[type=submit]").attr "disabled", true
#     $("#image").text("Uploading...")
#
#   $(document).on "upload:progress", "form", (e) ->
#     detail = e.originalEvent.detail.progress
#     percentComplete = Math.round(detail.loaded / detail.total * 100)
#     $("#upload-text").text("#{percentComplete}% uploaded")
#
#
#   $(document).on "upload:complete", "form", (e) ->
#     $(this).find("input[type=submit]").removeAttr "disabled"  unless $(this).find("input.uploading").length
#
#     # image_id = $("#ambassador_images_files").val()
#     # fileName = e.originalEvent.detail.file.name
#     # t = $("#upload-text").text() + ' ' + fileName
#     # $("#upload-text").text("#{t}")
#     #
#     # $("#image-thumbs").append $("<img />").attr(
#     #   src: "attachments/cache/fill/150/150/#{image_id}/image"
#     # )
