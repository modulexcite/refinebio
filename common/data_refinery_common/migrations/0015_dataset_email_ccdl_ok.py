# Generated by Django 2.1.5 on 2019-02-07 20:35

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('data_refinery_common', '0014_organism_experiments'),
    ]

    operations = [
        migrations.AddField(
            model_name='dataset',
            name='email_ccdl_ok',
            field=models.BooleanField(default=False),
        ),
    ]
