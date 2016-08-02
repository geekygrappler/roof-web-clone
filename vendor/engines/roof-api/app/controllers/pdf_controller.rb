require 'wicked_pdf'
class PdfController < ApplicationController
  def upload_pdf
    pdf = WickedPdf.new.pdf_from_string('ddddd')
    puts pdf
    render json: {pdf: pdf}
  end
end
