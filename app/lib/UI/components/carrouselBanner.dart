import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/carrouselBannerViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:ecom/core/models/carrouselData.dart';
import 'package:ecom/core/models/failure.dart';
import 'package:ecom/core/services/apiService.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarrouselBanner extends StatefulWidget {
  const CarrouselBanner({Key key}) : super(key: key);

  @override
  _CarrouselBannerState createState() => _CarrouselBannerState();
}

class _CarrouselBannerState extends State<CarrouselBanner>{
  @override
  Widget build(BuildContext context) {

    return BaseView<CarrouselBannerViewModel>(
      viewModel: CarrouselBannerViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, _) {
        if(!model.carrouselsAreLoading || model.carrousels != null)
          return model.carrousels.fold(
          (Failure f) => Center(
            child: Text(
              f.toString(), 
              textAlign: TextAlign.center, 
              style: TextStyle(
                color: SharedColors.secondaryColor, 
                fontSize: 20),
              ),
          ),
          (List<CarrouselData> carrousel) {
            model.pageCount = carrousel.length;
            return Stack(
              fit: StackFit.expand,
              children: [
                PageView(
                  scrollDirection: Axis.horizontal,
                  controller: model.pageController,
                  children: [
                    for(CarrouselData carr in carrousel)
                      Image.network(
                        carr.image ?? "${ApiService.endpoint}/static/defaultBanner.jpg",
                        height: 150,
                        fit: BoxFit.fill,
                      )
                  ],
                ),

                if(model.pageCount > 0)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SmoothPageIndicator(
                      controller: model.pageController, 
                      count: model.pageCount,
                      effect: WormEffect(

                      ),
                    ),
                  ),
              ],
            );
          }
        );
        else
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: SharedColors.defaultColor,
            ),
          );
      }
    );
  }

}