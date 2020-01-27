'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/assets/FontManifest.json": "9950208c63d1742f85e889bd3d9b4a40",
"/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"/assets/LICENSE": "c6641d284e5b6f36d1a8961a8367bf76",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-Regular.ttf": "778e16de3b7bbf4100f31ff4d6307216",
"/assets/fonts/Montserrat_Alternates/OFL.txt": "5da468cc0e208e63aa009460017f214a",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-Bold.ttf": "858597948628fafd5ba6d71a820cf7f6",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-MediumItalic.ttf": "eb22d47a0b4b7891695374c70effc968",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-Light.ttf": "9d57f922362adf8bf6e3ad79f01207ff",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-ExtraLight.ttf": "ce3e6591e29aa7808adb6aba6bd24d30",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-ExtraBoldItalic.ttf": "c07bb85cb211c8e4e69d31cfe42e1bcf",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-Black.ttf": "afa40ea840bfbd499ad6586e94c4e489",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-Italic.ttf": "9ad5b4624c9b7b582c8d0705779c9f53",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-Medium.ttf": "55b7b1d414ea6d2094b85e3a834e32b8",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-Thin.ttf": "6e886333f6bd82efa51d4c734d9a15b3",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-ExtraLightItalic.ttf": "9118d19c662e3cd69f6848c24a2dcb20",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-SemiBoldItalic.ttf": "584d58bbefcfdd1023cae6ae5ebc70f6",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-BlackItalic.ttf": "554197ea1f2aae385367a6d636cf152c",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-SemiBold.ttf": "2e719d5e579b791d74a1c5d84e0b766b",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-ExtraBold.ttf": "66e38dda7bea2a9ebb8f85e4b2a99ede",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-ThinItalic.ttf": "786e2b0cc485e13ae0403b42c3aca346",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-LightItalic.ttf": "1117f6b3d0340c3b0c5723f794f7d397",
"/assets/fonts/Montserrat_Alternates/MontserratAlternates-BoldItalic.ttf": "7ad02dea12bbc6e4d8ffadac7bc61c86",
"/assets/fonts/fonts.zip": "2c126dab2b1b5025e0d215cf02c9ae6a",
"/assets/fonts/MaterialIcons-Regular.ttf": "a37b0c01c0baf1888ca812cc0508f6e2",
"/assets/fonts/Muli/OFL.txt": "e2f8173e99e8005739bff48e44dfefbc",
"/assets/fonts/Muli/README": "992a653c9aed3d9b2b3126f46d21d2b9",
"/assets/fonts/Muli/Muli-VariableFont:wght.ttf": "e8efee929eb2218fdc84a27389f3968b",
"/assets/fonts/Muli/static/Muli-MediumItalic.ttf": "0b90460cef6cf999ada64176d3ed6f75",
"/assets/fonts/Muli/static/Muli-Italic.ttf": "001b006560d8d002237f41acb499b1a7",
"/assets/fonts/Muli/static/Muli-Regular.ttf": "328d557958b18b54b3bddb3a4a36215a",
"/assets/fonts/Muli/static/Muli-ExtraBoldItalic.ttf": "c67fbb97e13e0fe3194081787eafbd33",
"/assets/fonts/Muli/static/Muli-ExtraLightItalic.ttf": "e64995ee1141c41c5f6c7138167e32bf",
"/assets/fonts/Muli/static/Muli-Black.ttf": "ce5d61176e1db4c925df20db172e7a6a",
"/assets/fonts/Muli/static/Muli-ExtraLight.ttf": "28fb11e0b6998dc19246ff9e31d3b928",
"/assets/fonts/Muli/static/Muli-ExtraBold.ttf": "670ba44cafeef17fe4efd30d9fca548a",
"/assets/fonts/Muli/static/Muli-Medium.ttf": "683362f36187ad8be18692df9c1cf81e",
"/assets/fonts/Muli/static/Muli-BlackItalic.ttf": "a6dd7659d7e14f7b5900f6cbed92d62a",
"/assets/fonts/Muli/static/Muli-LightItalic.ttf": "750d43aadff57effe29e6bff6322d5cf",
"/assets/fonts/Muli/static/Muli-BoldItalic.ttf": "830cb281e41f1d8ec1db02adc684a3a5",
"/assets/fonts/Muli/static/Muli-SemiBoldItalic.ttf": "0eaa5a277c1d1b2eaae1a62e352e83f9",
"/assets/fonts/Muli/static/Muli-Light.ttf": "923c071b6b7ddaebd0c20d00fa805701",
"/assets/fonts/Muli/static/Muli-SemiBold.ttf": "2f64b5b99b8dc9d36387f334a6921da7",
"/assets/fonts/Muli/static/Muli-Bold.ttf": "077ceb9111e90dea3fc3923fe71805a1",
"/assets/fonts/Muli/Muli-Italic-VariableFont:wght.ttf": "2f6faf3a7b050dd458032c36ee82a02b",
"/assets/AssetManifest.json": "4078e73185314c4b5419d300edebba08",
"/index.html": "f32a0693a81073ce38d2f1c72eff1ae7",
"/main.dart.js": "197fab41a310d6500efb42bfedbfc004"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request, {
          credentials: 'include'
        });
      })
  );
});
