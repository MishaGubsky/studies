from setuptools import setup, find_packages

setup(
	name='lab2',
	version='1.0',
	packages=find_packages(),
	test_suite='nose.collector',
	test_require=['nose'],
	entry_points={
		'console_scripts':
			[
				'natural_sort = fusked.natural_merge_sort:main',
			]
	}
)