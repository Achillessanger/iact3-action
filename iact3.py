import asyncio
import sys

from iact3.exceptions import Iact3Exception
from iact3.main import run

if __name__ == "__main__":
    if sys.version_info[0] == 3 and sys.version_info[1] >= 7:
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        try:
            loop.run_until_complete(run())
        finally:
            loop.close()
    else:
        raise Iact3Exception("Please use Python 3.7+")
