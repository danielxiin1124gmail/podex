import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

//import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pages/about/about_page_store.dart';
import 'package:pokedex/modules/tennisPlayer_details/widgets/tennisPlayer_panel/pages/about/about_page_store.dart';

//import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pages/about/widget/animated_sprites.dart';
import 'package:pokedex/modules/tennisPlayer_details/widgets/tennisPlayer_panel/pages/about/widget/animated_sprites.dart';

//import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pages/about/widget/breeding_info.dart';
import 'package:pokedex/modules/tennisPlayer_details/widgets/tennisPlayer_panel/pages/about/widget/breeding_info.dart';

//import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pages/about/widget/height_weigh_info.dart';
import 'package:pokedex/modules/tennisPlayer_details/widgets/tennisPlayer_panel/pages/about/widget/height_weigh_info.dart';

//import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pages/about/widget/pokemon_cards.dart';
import 'package:pokedex/modules/tennisPlayer_details/widgets/tennisPlayer_panel/pages/about/widget/pokemon_cards.dart';

//import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pages/about/widget/sound_player.dart';
import 'package:pokedex/modules/tennisPlayer_details/widgets/tennisPlayer_panel/pages/about/widget/sound_player.dart';

//import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pages/about/widget/training_info.dart';
import 'package:pokedex/modules/tennisPlayer_details/widgets/tennisPlayer_panel/pages/about/widget/training_info.dart';

import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/stores/tennisPlayer_store/tennisPlayer_store.dart';

//import '../../pokemon_mobile_panel.dart';
import '../../tennisPlayer_mobile_panel.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  static final _tennisPlayerStore = GetIt.instance<TennisPlayerStore>();
  late AboutPageStore _aboutPageStoreStore;
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _aboutPageStoreStore = AboutPageStore();

    _player.onPositionChanged.listen((state) {
      // 估计是当拉动声音条时，要set audio progress到拉动的地方。
      _aboutPageStoreStore.setAudioProgress(state);
    });

    _player.onDurationChanged.listen((state) {
      // 类似于确认每个音源的长度，但他每个怪物叫声都只有1秒，尚未明白用意。
      _aboutPageStoreStore.setAudioTotal(state);
    });
  }

  @override
  void dispose() {
    // 他常常有这个dispose，释放资源。
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final size = MediaQuery.of(context).size;

    final horizontalPadding = getDetailsPanelsPadding(size);

    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
          child: Column(
            children: [
              // 下面的Observer，是制作最上面的简述 description。
              Observer(builder: (_) {
                if (_tennisPlayerStore.tennisPlayer!.soundUrl != null) {
                  _player
                      .setSourceUrl(_tennisPlayerStore.tennisPlayer!.soundUrl!);
                  // 这里要去API 获取音源的Url，然后他才能播放。
                  _player.pause(); //他预设暂停。
                }

                return Column(
                  // Column 里面是 children，复数，所以得toList()，并不是单个String。
                  children: _tennisPlayerStore.tennisPlayer!.descriptions
                      .map((it) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              it,
                              style: textTheme.bodyLarge,
                            ),
                          ))
                      .toList(),
                );
              }),
              // 下面的Observer，是制作播放条，长条两边圆弧之外，还有播放按钮、进度条。
              Observer(builder: (_) {
                if (_tennisPlayerStore.tennisPlayer!.soundUrl != null)
                  return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: SoundPlayer(
                      tennisPlayer: _tennisPlayerStore.tennisPlayer!,
                      player: _player,
                      tennisPlayerStore: _tennisPlayerStore,
                      aboutPageStore: _aboutPageStoreStore,
                    ),
                  );
                else
                  return Container();
              }),
              // 下面的Observer，是4个怪兽前后视图的上面两个。
              /*Observer(builder: (_) {
                if (_tennisPlayerStore.tennisPlayer!.hasAnimatedSprites)
                  return const AnimatedSpritesWidget(
                    isShiny: false,
                  );
                else
                  return Container();
              }),
              // 下面的Observer，是4个怪兽前后视图的下面两个，颜色变了一下
              Observer(builder: (_) {
                if (_pokemonStore.pokemon!.hasAnimatedShinySprites)
                  return const AnimatedSpritesWidget(
                    isShiny: true,
                  );
                else
                  return Container();
              }),
              // 下面的Padding，是怪兽身高体重。
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const HeightWeightInfoWidget(),
              ),
              // 下面的，包含 breeding 与 training 的各自的 widget。
              const BreedingInfoWidget(),
              const TrainingInfoWidget(),*/
            ],
          ),
        ),
        // 下面是最下面的宝贝卡片。不知道他为啥独立出来写在这，为啥不包含在上面的Children?
        // 若是单纯贴进去，padding会怪怪的，也许是原因吧。
        /*Observer(builder: (_) {
          if (_pokemonStore.pokemon!.cards.isNotEmpty) {
            return const PokemonCardsWidget();
          } else {
            return Container();
          }
        })*/
      ],
    );
  }
}
