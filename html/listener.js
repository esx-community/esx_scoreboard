var visable = false;

$(function () {
	window.addEventListener('message', function (event) {

		switch (event.data.action) {
			case 'toggle':

				if (visable) {
					$('#wrap').hide();
				} else {
					$('#wrap').show();
				}

				visable = !visable;
				break;

			case 'updatePlayerJobs':
				var json = JSON.parse(event.data.jobs);

				$('#player_count').html(json.player_count);

				$('#ems').html(json.ems);
				$('#police').html(json.police);
				$('#taxi').html(json.taxi);
				$('#mechanic').html(json.mechanic);
				$('#cardealer').html(json.cardealer);
				$('#bennys').html(json.bennys);
				$('#viktors').html(json.viktors);
				break;

			case 'updatePlayerList':
				$('#playerlist tr:gt(0)').remove();
				$('#playerlist').append(event.data.players);
				applyPingColor();
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

				break;

			default:
				console.log('scoreboard: unknown action!');
				break;
		}
	}, false);
});

function applyPingColor() {
	$('#playerlist tr').each(function () {
		$(this).find('td:nth-child(3)').each(function () {
			var ping = $(this).html();
			var color = 'green';

			if (ping > 60 && ping < 80) {
				color = 'orange';
			} else if (ping >= 80) {
				color = 'red';
			}

			$(this).css('color', color);
			$(this).html(ping + " <span style='color:white;'>ms</span>");
		});

	});
}

// Todo: not the best code
function updatePing(players) {
	jQuery.each(players, function (i, val) {
		$('#playerlist tr:not(.heading)').each(function () {
			$(this).find('td:nth-child(2):contains(' + val.id + ')').each(function () {
				$(this).parent().find('td').eq(2).html(val.ping);
			});
		});
	});
}