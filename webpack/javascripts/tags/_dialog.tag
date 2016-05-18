<r-dialog>
  <div class="fixed flex flex-center left-0 top-0 bottom-0 right-0 bg-darken-4 z30">

    <div class="relative clearfix mx-auto col-11 sm-col-6 md-col-5 lg-col-4 flex-center bg-white border border-darken-3 rounded shadow dialog">
      <div class="p1 bg-darken-2 gray">
        <h1 class="h4 m0 inline-block mr2">{opts.title}</h1>
        <a class="center btn btn-small gray absolute right-0 top-0 mt1 mr1" onclick="{unsetActivity}"><i class="fa fa-times"></i></a>
      </div>
      <yield />
    </div>

  </div>
</r-dialog>
