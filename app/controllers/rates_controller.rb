# Could be powerful, allowing editing of Item, ItemAction & ItemSpec :-S
class RatesController < ApplicationController

    # GET /rates.html
    def index
        @rates = Rate.all
        respond_to do |format|
            format.html { @rates }
        end
    end

    # GET /rates/new.html
    def new
        @rate = Rate.new
    end

    # POST /rates.html
    def create

    end
end
