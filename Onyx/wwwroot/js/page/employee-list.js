$('#tileViewTable').DataTable({
    "paging": false, // Disable pagination
    "info": false, // Disable info text
    "searching": false, // Disable search
    "columnDefs": [
        { "targets": "_all", "visible": false } // Hide table columns
    ],
    "drawCallback": function (settings) {
        var api = this.api();
        var rows = api.rows({ page: 'current' }).nodes();
        var last = null;

        $('.tile-container').empty(); // Clear existing tiles

        var tileRow = $('<div class="tile-row"></div>'); // Create a new row

        api.column(0, { page: 'current' }).data().each(function (group, i) {
            var tile = '<div class="tile"><b>' + group + '</b></div>';
            tileRow.append(tile); // Append tile to the current row

            // If the row contains three tiles or it's the last tile, append the row to the container
            if ((i + 1) % 3 === 0 || i === api.column(0, { page: 'current' }).data().length - 1) {
                $('.tile-container').append(tileRow);
                tileRow = $('<div class="tile-row"></div>'); // Create a new row
            }
        });
    }
});