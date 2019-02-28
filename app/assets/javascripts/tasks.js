document.addEventlistener('turbolinks:load', function() {
  document.querySelectorAll('td').forEach(function(td) {
    td.addEventlistener('mouseover', function(e) {
      e.currentTarget.style.backgroundColor = '#eff';
    });

    td.addEventlistener('mouseout', function(e) {
      e.currentTarget.style.backgroundColor = '';
    });
  });
});
