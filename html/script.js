var visible = false;

$(function() {
	window.addEventListener('message', function(event) {
		switch (event.data.action) {
			case 'toggle':
				if (visible) {
					$('#wrap').hide();
				} else {
					$('#wrap').show();
				}
	
				visible = !visible;
				break;

			case 'toggleID':
				if (event.data.state) {
					$('td:nth-child(2),th:nth-child(2)').show();
				} else {
					$('td:nth-child(2),th:nth-child(2)').hide();
				}

				break;

			case 'updatePlayerJobs':
				var jobs = event.data.jobs;
				$('#player_count').html(jobs.player_count);
				$('#ems').html(jobs.ems);
				$('#police').html(jobs.police);
				$('#taxi').html(jobs.taxi);
				$('#mechanic').html(jobs.mechanic);
				$('#cardealer').html(jobs.cardealer);
				$('#estate').html(jobs.estate);
				break;

			case 'updatePlayerList':
				$('.playerlist tr:gt(0)').remove();
				$('.playerlist').append(event.data.players);
				applyPingColor();
				sortPlayerList();
				break;

			case 'updatePing':
				updatePing(event.data.players);
				applyPingColor();
				break;

			case 'updateServerInfo':
				if (event.data.maxPlayers) {
					$('#max_players').html(event.data.maxPlayers);
				}

				if (event.data.uptime) {
					$('#server_uptime').html(event.data.uptime);
				}

				if (event.data.playTime) {
					$('#play_time').html(event.data.playTime);
				}

				if (event.data.playersInQueue) {
					$('#players_in_queue').html(event.data.playersInQueue);
				}

				break;

			default:
				break;
		}
	});
});

function applyPingColor() {
	$('.playerlist tr:not(:first-child)').each(function() {
		$(this).find('td:nth-child(3)').each(function() {
			var ping = $(this).html();

			if (ping == 'missing') {
				$(this).css('color', 'orange');
			} else {
				var color = 'green';

				if (ping > 50 && ping < 80) {
					color = 'orange';
				} else if (ping >= 80) {
					color = 'red';
				}

				$(this).css('color', color);
				$(this).html(ping + " <span style='color:white;'>ms</span>");
			}
		});
	});
}

function updatePing(players) {
	$.each(players, function(index, element) {
		if (element != null) {
			$('.playerlist tr:not(:first-child)').each(function() {
				$(this).find('td:nth-child(2):contains(' + element.playerId + ')').each(function() {
					$(this).parent().find('td').eq(2).html(element.ping);
				});
			});
		}
	});
}

function sortPlayerList() {
	var table = $('.playerlist'),
		rows = $('tr:not(:first-child)', table);

	rows.sort(function(a, b) {
		var keyA = $('td', a).eq(1).html();
		var keyB = $('td', b).eq(1).html();

		return (keyA - keyB);
	});

	rows.each(function(index, row) {
		table.append(row);
	});
}
