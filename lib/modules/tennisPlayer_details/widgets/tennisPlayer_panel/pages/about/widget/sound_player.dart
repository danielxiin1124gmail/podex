import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pages/about/about_page_store.dart';
import 'package:pokedex/modules/tennisPlayer_details/widgets/tennisPlayer_panel/pages/about/about_page_store.dart';

//import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pokemon_mobile_panel.dart';
import 'package:pokedex/modules/tennisPlayer_details/widgets/tennisPlayer_panel/tennisPlayer_mobile_panel.dart';

import 'package:pokedex/shared/models/pokemon.dart';
import 'package:pokedex/shared/models/tennisPlayer.dart';

import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/stores/tennisPlayer_store/tennisPlayer_store.dart';

import 'package:pokedex/theme/app_theme.dart';

class SoundPlayer extends StatelessWidget {
  final AboutPageStore aboutPageStore;
  final TennisPlayerStore tennisPlayerStore;
  final AudioPlayer player;
  final TennisPlayer tennisPlayer;

  const SoundPlayer(
      {Key? key,
      required this.aboutPageStore,
      required this.player,
      required this.tennisPlayer,
      required this.tennisPlayerStore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final horizontalPadding = getDetailsPanelsPadding(size);

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        // 這個Container就是播放那一条，两边有圆弧。
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.getColors(context).panelBackground,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // IconButton 是左边的播放按钮。
            IconButton(
              icon: FaIcon(
                // FaIcon 来自 font_awesome_flutter，与其下载一堆图标，这package可以关联到其API获取图标。
                FontAwesomeIcons.play, //这就是播放的图标。
                color: AppTheme.getColors(context)
                    .tennisPlayerItem(tennisPlayer.types[0]),
              ),
              onPressed: () async {
                // 好像其实不用 async，删除了也没error。
                player.seek(Duration.zero); // 这duration删除了也没差。
                player.play(UrlSource(tennisPlayer.soundUrl!));
              },
            ),
            // 下面就是进度条的设定。
            SizedBox(
              child: Observer(
                builder: (_) => ProgressBar(
                  progress: aboutPageStore.audioProgress,
                  total: aboutPageStore.audioTotal,
                  progressBarColor: AppTheme.colors.tennisPlayerItem(
                      tennisPlayerStore.tennisPlayer!.types[0]),
                  baseBarColor: AppTheme.colors
                      .tennisPlayerItem(
                          tennisPlayerStore.tennisPlayer!.types[0])
                      .withOpacity(0.1),
                  bufferedBarColor: AppTheme.colors
                      .tennisPlayerItem(
                          tennisPlayerStore.tennisPlayer!.types[0])
                      .withOpacity(0.1),
                  thumbColor: AppTheme.colors.tennisPlayerItem(
                      tennisPlayerStore.tennisPlayer!.types[0]),
                  timeLabelLocation: TimeLabelLocation.sides,
                  onSeek: (duration) {
                    player.seek(duration);
                  },
                ),
              ),
              width: size.width * 0.65 - horizontalPadding,
            )
          ],
        ),
      ),
    );
  }
}
