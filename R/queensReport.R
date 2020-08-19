#' Queens Report (PDF)
#'
#' This function can be used to render the Queens report template. This is based on https://github.com/INWTlab/ireports
#'
#' @inheritParams rmarkdown::pdf_document
#' @param template character; Pandoc template to use for rendering. Pass
#' \code{"QueensTemplate"} to use the default example template
#' @param resetStyleFiles logical; should the style files (logo, cover, defs.tex) be overwritten with the default files?
#' @param ... further arguments passed to \code{\link[rmarkdown]{pdf_document}}
#'
#' @details The function serves as wrapper to \code{\link[rmarkdown]{pdf_document}}
#' only steering the selection of the template.
#'
#' @export

queensReport <- function(template = "QueensTemplate", resetStyleFiles = FALSE,...) {

  # The following code is taken from rmarkdown::pdf_document() (v1.1)
  # template path and assets

  if (identical(template, "QueensTemplate")) {

    pandoc_available(error = TRUE)
    # choose the right template
    version <- pandoc_version()
    if (version >= "1.17.0.2") latex_template <- "template-1.17.0.2.tex"
    else stop("Pandoc Version has to be >=1.17.0.2")

    template <- system.file(
      paste0("rmarkdown/templates/QueensTemplate/", latex_template),
      package = "QueensTemplate",
      mustWork = TRUE
    )

    # Copy required tex/rmd files to Rmd Working Directory
    path <- system.file(
      "rmarkdown/templates/QueensTemplate/skeleton/",
      package = "QueensTemplate",
      mustWork = TRUE
    )


    filesToCopy <- unlist(lapply(path, list.files, full.names = FALSE))

    # remove `skeleton.Rmd` from `filesToCopy`
    filesToCopy <- filesToCopy[filesToCopy != "skeleton.Rmd"]

    invisible(mapply(
      function(pfad, files) {
        file.copy(
          from = paste0(pfad, "/", files),
          to = files,
          overwrite = resetStyleFiles
        )
      },
      pfad = path,
      files = filesToCopy
    ))

  }

  # call the base pdf_document format with the appropriate options
  pdf_document(template = template,  pandoc_args = c("--variable", "graphics=yes"), ...)

}
