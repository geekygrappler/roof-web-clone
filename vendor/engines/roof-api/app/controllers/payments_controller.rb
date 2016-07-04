class PaymentsController < ResourceController

  def approve
    if @record.approve(permitted_params[:fee])
      head :no_content
    else
      render(errors_response)
    end
  end

  def cancel
    if @record.cancel
      head :no_content
    else
      render(errors_response)
    end
  end

  def pay
    paid = @record.pay(current_account.user, params[:token])
    if paid
      head :no_content
    else
      render(errors_response)
    end
  end

  def refund
    if @record.reimburse
      head :no_content
    else
      render(errors_response)
    end
  end

  protected

  def set_records
    super
    @records = @records.where(quote_id: params[:quote_id]) if params[:quote_id]
    @records
  end

  def permitted_attributes
    [
      :project_id,
      :professional_id,
      :quote_id,
      :fee,
      :amount,
      :due_date,
      :description
    ]
  end

end
