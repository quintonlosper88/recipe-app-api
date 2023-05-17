"""
Django command to wait for the database to be available.
To avoid database race conditions.
"""
import time

from psycopg2 import OperationalError as Psycopg2OpError
from django.db.utils import OperationalError
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    """Django command to wait for database"""

    def handle(self, *args, **options):
        """Entrypoint for teh command"""
        self.stdout.write('Waiting for database...')
        """we assume the database is not up"""
        db_up = False
        while db_up is False:
            try:
                """check if the database is ready. if not throw an exception.
                if true set db_up equal to True"""
                self.check(databases=['default'])
                db_up = True
            except (Psycopg2OpError, OperationalError):
                self.stdout.write('Database unavailable, wiating 1 second...')
                time.sleep(1)

        self.stdout.write(self.style.SUCCESS('Database avaialble!'))
