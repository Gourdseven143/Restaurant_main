// ignore_for_file: unrelated_type_equality_checks

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/custom_btn.dart';
import 'package:foodly_restaurant/common/reusable_text.dart';
import 'package:foodly_restaurant/common/row_text.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/controllers/foods_controller.dart';
import 'package:foodly_restaurant/models/foods.dart';
import 'package:foodly_restaurant/views/food/edit_food_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key, required this.food});

  final Food food;

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodController = Get.put(FoodsController());

    return Scaffold(
        backgroundColor: kLightWhite,
        body: ListView(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.only(bottomRight: Radius.circular(25)),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 230.h,
                        child: PageView.builder(
                            itemCount: widget.food.imageUrl.length,
                            controller: _pageController,
                            onPageChanged: (i) {
                              foodController.currentPage(i);
                            },
                            itemBuilder: (context, i) {
                              return Container(
                                height: 230.h,
                                width: width,
                                color: kLightWhite,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: widget.food.imageUrl[i],
                                ),
                              );
                            }),
                      ),
                      Positioned(
                        bottom: 10,
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.food.imageUrl.length,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    margin: EdgeInsets.all(4.h),
                                    width: foodController.currentPage == index
                                        ? 10
                                        : 8,
                                    height: foodController.currentPage == index
                                        ? 10
                                        : 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: foodController.currentPage == index
                                          ? kSecondary
                                          : kGrayLight,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 40.h,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Ionicons.chevron_back_circle,
                          color: kPrimary,
                          size: 28,
                        ),
                      ),
                    
                    ],
                  ),
                ),
                Positioned(
                    bottom: 10,
                    right: 15,
                    child: CustomButton(
                        btnWidth: width / 2.9,
                        radius: 30,
                        color: kPrimary,
                        onTap: () {
                          Get.to(EditFoodPage(food: widget.food,));
                        },
                        text: "Edit Food"))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableText(
                          text: widget.food.title,
                          style: appStyle(kFontSizeBodyLarge, kDark, FontWeight.w600)),
                      ReusableText(
                            text: "\$ ${widget.food.price.toString()}",
                            style: appStyle(kFontSizeBodyLarge, kPrimary, FontWeight.w600)),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    widget.food.description!,
                    maxLines: 8,
                    style: appStyle(kFontSizeBodySmall, kGray, FontWeight.w400),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  ReusableText(
                      text: "Food Tags",
                      style: appStyle(kFontSizeBodyLarge, kDark, FontWeight.w600)),
                  
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 15.h,
                    child: ListView.builder(
                        itemCount: widget.food.foodTags.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          final tag = widget.food.foodTags[i];
                          return Container(
                            margin: EdgeInsets.only(right: 5.h),
                            decoration: BoxDecoration(
                                color: kPrimary,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.r))),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: ReusableText(
                                    text: tag,
                                    style: appStyle(
                                        8, kLightWhite, FontWeight.w400)),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  ReusableText(
                      text: "Additives and Toppings",
                      style: appStyle(kFontSizeBodyLarge, kDark, FontWeight.w600)),
                  Column(
                    children: List.generate(widget.food.additives.length, (i) {
                      final additive = widget.food.additives[i];
                      return CheckboxListTile(
                        title: RowText(
                            first: additive.title,
                            second: "\$ ${additive.price}"),
                        contentPadding: EdgeInsets.zero,
                        value: true,
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        onChanged: (bool? newValue) {},
                        activeColor: kPrimary,
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        tristate: false,
                      );
                    }),
                  ),
                  
                  SizedBox(
                    height: 15.h,
                  ),
                  ReusableText(
                      text: "Food Type",
                      style: appStyle(kFontSizeBodyLarge, kDark, FontWeight.w600)),
                  
                  SizedBox(
                    height: 10.h,
                  ),
                  
                  SizedBox(
                    height: 19.h,
                    child: ListView.builder(
                        itemCount: widget.food.foodType.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          final tag = widget.food.foodTags[i];
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            // width: 60.h,
                            height: 19.h,
                            decoration: const BoxDecoration(
                                color: kPrimary,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                            child: Center(
                              child: ReusableText(
                                text: tag,
                                style: appStyle(kFontSizeSubtext, kLightWhite, FontWeight.bold),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),


            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                      text: 'Created At:',
                      style: appStyle(kFontSizeBodyLarge, kDark, FontWeight.w600)),
                  ReusableText(
                      text: " ${widget.food.createdAt != null ? DateFormat('yyyy-MM-dd').format(widget.food.createdAt!) : 'N/A'}",
                      style: appStyle(kFontSizeBodyLarge, kPrimary, FontWeight.w600)),
                ],
              ),
            ),

            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                      text: 'Updated At:',
                      style: appStyle(kFontSizeBodyLarge, kDark, FontWeight.w600)),
                  ReusableText(
                      text: " ${widget.food.updatedAt != null ? DateFormat('yyyy-MM-dd').format(widget.food.updatedAt!) : 'N/A'}",
                      style: appStyle(kFontSizeBodyLarge, kPrimary, FontWeight.w600)),

                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                      text: "Status",
                      style: appStyle(kFontSizeBodyLarge, kDark, FontWeight.w600)),
                  ReusableText(
                      text: widget.food.verified==false?"being verified":"fine",
                      style: appStyle(kFontSizeBodyLarge, kPrimary, FontWeight.w600)),
                ],
              ),
            ),
            SizedBox(
              height: 40.h,

            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal:8.h),
              child: CustomButton(text: "D E L E T E", onTap: () {
                
              },
              color: kRed,
              btnHieght: 35,
              ),
            )
          ],
        ));
  }
}
