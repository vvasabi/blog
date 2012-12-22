jQuery(window).load(function () {
  jQuery('a.view-comments').each(function () {
    jQuery(this).prepend('<i class="icon-comment"></i> ');
  });
});
