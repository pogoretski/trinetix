<html>
	<head>
		<title>Tree for Trinetix</title>
		<script src="s/js/jquery-1.8.3.min.js"></script>
	</head>
	<body>
		<ul>
		<?php foreach ($start_tree as $node): ?>
			<?php if ( $node['childs'] > 0 ): ?>
				<li id="<?php echo $node['id'];?>"><span>[+]</span> <?php echo $node['name'];?> (<?php echo $node['childs'];?>)</li>
			<?php else: ?>
				<li>[-] <?php echo $node['name'];?></a> (<?php echo $node['childs'];?>)</li>
			<?php endif; ?>
		<?php endforeach; ?>
		</ul>
	
	</body>
</html>

<script>
$(document).ready(function() {
	$('li').mousedown(function(event) {
		mouseProcess(this, event);
	});
});

function mouseProcess(obj, event){
	 switch (event.which) {
	        case 1: // Left mouse button
	            if ($(obj).hasClass('opened'))
	            	hideChild($(obj).attr('id'));
	            else
	            	showChild($(obj).attr('id'));
	            break;
	        case 2:
	            break;
	        case 3: // Right mouse button
	           if ($(obj).hasClass('opened'))
	            	hideChild($(obj).attr('id'));
	            else
	            	showAllChild($(obj).attr('id'));
	            break;
	        default:
	           break;
	    }
}

function showChild(parentId){
	$.post("/", { "func": "getChild", "parentId": parentId },
	  function(data){
	    if ( ( data.count > 0 ) && ( data.children != false ) )
	    {
	    	var obj = $('#'+parentId);
	    	
			$('<ul></ul>').insertAfter($(obj));
	    	for (var i=0; i<data.count; i++)
	    	{
	    		if(data.children[i].childs > 0)
	    		{
	    			// If we have node:
	    			$(obj).next().append('<li id="'+data.children[i].id+'"><span>[+]</span>'+data.children[i].name+' ('+data.children[i].childs+')</li>');
	    			$('#'+data.children[i].id).on('mousedown', function(event) { mouseProcess($(this), event);});
	    		}
	    		else // If it's a leaf
	    			$(obj).next().append('<li>[-] '+data.children[i].name+' ('+data.children[i].childs+')</li>');
	    		
	    	}
	    	$(obj).addClass('opened');
	    	$(obj).find('span').text('[-]');
	    }
	  }, "json");
	
	return false;
}

function showAllChild(parentId){
	$.post("/", { "func": "getFullPath", "parentId": parentId },
	  function(data){
	    if ( ( data.count > 0 ) && ( data.children != false ) )
	    {
	    	var obj = $('#'+parentId);
	    	
			var prev_depth=0;
			var tree = '';
	    	for (var i=0; i<data.count; i++)
	    	{
	    		if(data.children[i].depth > prev_depth)
	    		{
	    			prev_depth = data.children[i].depth;
	    			tree += '<ul>';	    			
	    		} 
	    		else if(data.children[i].depth < prev_depth)
	    		{
	    			prev_depth = data.children[i].depth;
	    			tree += '</ul>';	    			
	    		}
	    		
	    		if(data.children[i].childs > 0)
	    		{
	    			tree += '<li id="'+data.children[i].id+'" class="opened"><span>[-]</span>'+data.children[i].name+' ('+data.children[i].childs+')</li>';
	    		}
	    		else{
	    			tree +='<li>[-] '+data.children[i].name+' ('+data.children[i].childs+')</li>';
	    		}
	    		
	    	}
	    	
	    	$(obj).addClass('opened');
	    	$(tree).insertAfter($(obj));
	    	$(obj).find('span').text('[-]');
	    	
	    	for (var i=0; i<data.count; i++)
	    	{
	    		// Activate event listeners for new elements
	    		if(data.children[i].childs > 0)
	    		{
	    			$('#'+data.children[i].id).on('mousedown', function(event) { mouseProcess($(this), event);});
	    		}
	    	}
	    }
	  }, "json");
	
	return false;
}

function hideChild(parentId){
	var obj = $('#'+parentId);
	$(obj).next().remove();
	$(obj).removeClass('opened');
	$(obj).find('span').text('[+]');
	return false;
}
</script>

<style type="text/css">
li {cursor:pointer}
 </style>