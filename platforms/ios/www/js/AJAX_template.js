/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$(document).on('pageinit', "#page", function() {
    // for example: displayFooter();
    loadContent("main");
    loadMenu("default");
});

function loadContent(location) {
    return $('#content').load("views/content/"+location+".html", function() { 
        $(this).trigger('create');
    });
}
function loadMenu(location) {
    $("#menu").remove();
    $("#navbar").remove();

    $("#footer").html('<div data-role="navbar" id="navbar">');
    $("#navbar").html('<ul id="menu"></ul>');

    $("#menu").load("views/menus/"+location+".html", function() { $("#menu").parent().navbar(); });

    return true;
}