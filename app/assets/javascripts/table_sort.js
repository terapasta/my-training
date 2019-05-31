$(document).on('turbolinks:load', function() {
  return $(function() {
    return $('.table-sortable').sortable({
      axis: 'y',
      items: '.item',
      update: function(e, ui) {
        var item, item_data, params;
        item = ui.item;
        item_data = item.data();
        params = {
          _method: 'put'
        };
        params[item_data.model_name] = {
          row_order_position: item.index()
        };
        return $.ajax({
          type: 'POST',
          url: item_data.update_url,
          dataType: 'json',
          data: params
        });
      }
    });
  });
});
