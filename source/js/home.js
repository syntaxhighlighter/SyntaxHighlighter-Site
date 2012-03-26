(function()
{
	var about    = $('#about-section'),
		masthead = $('#masthead .content'),
		blocks   = [],
		left     = $('#left'),
		right    = $('#right')
		;
	
	about.find('p:nth(0), p:nth(1)').appendTo(masthead);

	about.find('> *').each(function()
	{
		var item = $(this);

		if(item.is('h2'))
			blocks.push([ item ]);
		else
			blocks[blocks.length - 1].push(item);
	});

	function move(index, to)
	{
		$(blocks[index]).each(function()
		{
			$(this).appendTo(to);
		});
	}

	move(0, left);  // about
	move(1, left);  // features
	move(3, left);  // how to use
	move(2, right); // example

	$('#textarea').textext({
		plugins : 'tags prompt focus autocomplete ajax arrow',
		tagsItems : [ 'Basic', 'JavaScript', 'PHP', 'Scala' ],
		prompt : 'Add one...',
		ajax : {
			url : '/manual/examples/data.json',
			dataType : 'json',
			cacheResults : true
		}
	});

	$('#donate-alert').insertAfter('#first-row');
})();
