$(document).on("upload:start", "form", function(e) {
  $(this).find("input[type=submit]").attr("disabled", true);

  progressBar = $("#" + $(e.target).data("progressbar")).parent();
  progressBar.removeClass("hidden");
  progressBar.addClass("show");
});

$(document).on("upload:progress", "form", function(e) {
  // Get the progress bar to modify
  progressBar = $("#" + $(e.target).data("progressbar"));

  // Process upload details to get the percentage complete
  uploadDetail = e.originalEvent.detail;
  percentLoaded = uploadDetail.loaded;
  totalSize = uploadDetail.total;
  percentageComplete = Math.round((percentLoaded / totalSize) * 100);

  // Reflect the percentage on the progress bar
  progressBar.css("width", percentageComplete + "%");
  progressBar.text(percentageComplete + "%");
});

$(document).on("upload:success", "form", function(e) {
  progressBar = $("#" + $(e.target).data("progressbar"));
  progressBar.addClass("progress-bar-success");
});

$(document).on("upload:failure", "form", function(e) {
  progressBar = $("#" + $(e.target).data("progressbar"));
  progressBar.addClass("progress-bar-danger");
});

$(document).on("upload:complete", "form", function(e) {
  if(!$(this).find("input.uploading").length) {
    $(this).find("input[type=submit]").removeAttr("disabled");
  }
});
