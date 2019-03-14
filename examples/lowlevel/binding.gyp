{
    "targets": [
        {
            "target_name": "myaddon",
            "sources": [
                "<!@(node -p \"require('fs').readdirSync('./nimbuild/csrc').map(f=>'nimbuild/csrc/'+f).join(' ')\")",
            ],
            'cflags!': [ '-fno-exceptions' ],
            'cflags_cc!': [ '-fno-exceptions' ],
            'cflags_cc': [ "-fPIC" ],
            'xcode_settings': {
                'GCC_ENABLE_CPP_EXCEPTIONS': 'YES',
                'CLANG_CXX_LIBRARY': 'libc++',
                'MACOSX_DEPLOYMENT_TARGET': '10.7',
            },
            "msbuild_settings": {
                "Link": {
                    "ImageHasSafeExceptionHandlers": "false"
                }
            },
        }
    ]
}