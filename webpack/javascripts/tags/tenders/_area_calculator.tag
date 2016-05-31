<r-area-calculator>
  <div class="clearfix mxn2">
    <div class="sm-col sm-col-4 px2">
      <label>Width</label>
      <input type="number" name="width" min="0" step="0.1" class="block col-12 mb2 field" value="{opts.dimensions[0]}" oninput="{update}" >
    </div>
    <div class="sm-col sm-col-4 px2">
      <label>Height</label>
      <input type="number" name="height" min="0" step="0.1" class="block col-12 mb2 field" value="{opts.dimensions[1]}" oninput="{update}" >
    </div>
    <div class="sm-col sm-col-4 px2">
      <label>Length</label>
      <input type="number" name="length" min="0" step="0.1" class="block col-12 mb2 field" value="{opts.dimensions[2]}" oninput="{update}" >
    </div>
  </div>

  <div class="clearfix mxn2">
    <div class="sm-col sm-col-4 px2">
      <label>Wall Area</label>
      <input type="submit" class="block col-12 mb2 btn bg-blue white"  value="{wallArea(width.value, height.value, length.value)}" onclick="{opts.callback}" >
    </div>
    <div class="sm-col sm-col-4 px2">
      <label>Floor Area</label>
      <input type="submit" class="block col-12 mb2 btn bg-blue white"  value="{floorArea(width.value, height.value, length.value)}" onclick="{opts.callback}" >
    </div>
    <div class="sm-col sm-col-4 px2">
      <label>Wall Length</label>
      <input type="submit" class="block col-12 mb2 btn bg-blue white"  value="{wallLength(width.value, height.value, length.value)}" onclick="{opts.callback}" >
    </div>
  </div>

  <script>
  this.wallArea = (w, h, l) => (2 * w * h) + (l + h * 2)
  this.floorArea = (w, h, l) => w * l
  this.wallLength = (w, h, l) => (2 * w) + (2 * l)
  </script>
</r-area-calculator>
