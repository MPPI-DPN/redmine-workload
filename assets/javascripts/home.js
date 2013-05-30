$(function(){
    $('#timeline').gantt({
        source: document.location.href+".json",
        scale: "days",
        itemsPerPage: 100,
        minScale: "days",
        maxScale: "months",
        onItemClick: function(data) {
            alert("Item clicked - show some details");
        },
        onAddClick: function(dt, rowId) {
            alert("Empty space clicked - add an item!");
        },
        onRender: function() {
            console.log("chart rendered");
        }
    });
});