#!/usr/bin/env python3

# Copyright © 2012-2022 Jonathan Vasquez <jon@xyinn.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

from subprocess import run

import pkg.libs.Variables as var

from pkg.libs.Core import Core
from pkg.libs.Tools import Tools
from pkg.hooks.Modules import Modules


class Main:
    # Let the games begin ...
    @classmethod
    def start(cls):
        Tools.ProcessArguments(Modules)
        run(["clear"], check=False)
        Tools.PrintHeader()
        Core.LoadSettings()
        Core.AddFilesAfterSettingsLoaded()
        Core.SetAndCheckDesiredKernel()
        Core.VerifySupportedArchitecture()
        Tools.Clean()
        Core.VerifyPreliminaryBinaries()
        Core.CreateBaselayout()
        Core.VerifyBinaries()
        Core.CopyBinaries()
        Core.CopyManPages()
        Core.CopyModules()
        Core.CopyFirmware()

        # Dependencies must be copied before we create links since the commands inside of
        # the create links (i.e chroot) function require that the libraries are already
        # in our chroot environment.
        Core.CopyDependencies()
        Core.CreateLinks()
        Core.LastSteps()
        Core.CreateInitramfs()
        Tools.CleanAndExit(var.initrd)


if __name__ == "__main__":
    Main.start()
